// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using UnityEditor;
using UnityEditor.IMGUI.Controls;
using UnityEngine;
#if ABT_DEBUG
using System;
using Cortopia.Scripts.Reactivity;
using System.Collections.Generic;
using System.Linq;
using UnityEngine.UI;
#endif

namespace Cortopia.Scripts.AI.ABT.Editor
{
    public class BehaviorTreeDebugger : EditorWindow
    {
        // SerializeField is used to ensure the view state is written to the window 
        // layout file. This means that the state survives restarting Unity as long as the window
        // is not closed. If the attribute is omitted then the state is still serialized/deserialized.
        [SerializeField]
        // ReSharper disable once NotAccessedField.Local
        private TreeViewState treeViewState;

#if ABT_DEBUG
        private Button _button;

        //The TreeView is not serializable, so it should be reconstructed from the tree data.
        private DebuggerTreeView _treeView;

        private void OnEnable()
        {
            this.treeViewState ??= new TreeViewState();
            this._treeView = new DebuggerTreeView(this.treeViewState);
        }

        private void OnDisable()
        {
            this._treeView?.Dispose();
        }

        private void OnGUI()
        {
            if (EditorApplication.isPlaying)
            {
                bool? toggle = this._treeView.Break;
                if (toggle.HasValue)
                {
                    bool breakToggle = GUI.Toggle(new Rect(0, 0, 100, 20), toggle.Value, "Break", new GUIStyle("Button") {alignment = TextAnchor.MiddleCenter});
                    if (toggle.Value != breakToggle)
                    {
                        this._treeView.Break = breakToggle;
                        this._treeView.Reload();
                    }
                }

                if (this._treeView.AllIsRunning)
                {
                    if (GUI.Button(new Rect(150, 0, 100, 20), "Force Success"))
                    {
                        this._treeView.ForceStop(true);
                    }
                    else if (GUI.Button(new Rect(250, 0, 100, 20), "Force Fail"))
                    {
                        this._treeView.ForceStop(false);
                    }
                }
            }

            this._treeView?.OnGUI(new Rect(0, 25, this.position.width, this.position.height - 25));
        }

        // Add menu named "My Window" to the Window menu
        [MenuItem("Window/AI/Async Behavior Tree/Debugger")]
        private static void ShowWindow()
        {
            // Get existing open window or if none, make a new one:
            var window = GetWindow<BehaviorTreeDebugger>();
            window.titleContent = new GUIContent("Async Behavior Tree Debugger");
            window.Show();
        }

        private class DebuggerTreeView : TreeView, IDisposable
        {
            private readonly Dictionary<BehaviorTreeRunner, bool> _activeAndEnabledRunners = new();
            private readonly Texture2D _breakButton;
            private readonly Texture2D _brokenButton;
            private ReactiveSubscription _subscription;

            public DebuggerTreeView(TreeViewState treeViewState) : base(treeViewState)
            {
                this.Reload();
                this._breakButton = EditorGUIUtility.FindTexture("d_winbtn_mac_close");
                this._brokenButton = EditorGUIUtility.FindTexture("d_Record On");
            }

            public bool? Break
            {
                get
                {
                    var selection = this.GetSelection();
                    return selection.Count == 0 ? null : selection.All(id => this.FindItem(id, this.rootItem) is DebuggerTreeViewItem item && item.Status.BreakPointSet);
                }
                set
                {
                    if (!value.HasValue || value == this.Break)
                    {
                        return;
                    }

                    foreach (int id in this.GetSelection())
                    {
                        if (this.FindItem(id, this.rootItem) is DebuggerTreeViewItem item)
                        {
                            item.Status.BreakPointSet = value.Value;
                        }
                    }
                }
            }

            public bool AllIsRunning
            {
                get
                {
                    var selection = this.GetSelection();
                    return selection.Count > 0 && selection.All(id =>
                        this.FindItem(id, this.rootItem) is DebuggerTreeViewItem item && item.Status.Status.Value == Status.Running);
                }
            }

            public void Dispose()
            {
                this._subscription.Dispose();
                this._subscription = default(ReactiveSubscription);
            }

            public void ForceStop(bool result)
            {
                foreach (int id in this.GetSelection())
                {
                    if (this.FindItem(id, this.rootItem) is DebuggerTreeViewItem item)
                    {
                        item.Status.ForceStop(result);
                    }
                }
            }

            protected override TreeViewItem BuildRoot()
            {
                this.Dispose();
                var root = new DebuggerTreeViewItem
                {
                    id = 0,
                    depth = -1,
                    displayName = "Root",
                    Status = new StatusTracer(Status.Running),
                    children = new List<TreeViewItem>()
                };
                int id = 1;
                this._activeAndEnabledRunners.Clear();
                foreach (BehaviorTreeRunner x in FindObjectsOfType<BehaviorTreeRunner>(true))
                {
                    root.children.Add(this.BuildTree(root, x, ref id, x.StatusTracer));
                    this._activeAndEnabledRunners[x] = x.isActiveAndEnabled && x.StatusTracer.Status.Value is Status.NotRunning or Status.Running;
                }

                return root;
            }

            public override void OnGUI(Rect rect)
            {
                this.CheckDirty();
                base.OnGUI(rect);
            }

            private void CheckDirty()
            {
                if (this._activeAndEnabledRunners.Keys.Any(runner => !runner))
                {
                    this.Reload();
                }

                foreach (BehaviorTreeRunner x in FindObjectsOfType<BehaviorTreeRunner>(true))
                {
                    if (!this._activeAndEnabledRunners.TryGetValue(x, out bool wasEnabled) ||
                        wasEnabled != (x.isActiveAndEnabled && x.StatusTracer.Status.Value is Status.NotRunning or Status.Running))
                    {
                        this.Reload();
                        return;
                    }
                }
            }

            private TreeViewItem BuildTree(TreeViewItem parent, IBehaviorTreeTracer child, ref int id, StatusTracer status)
            {
                var item = new DebuggerTreeViewItem
                {
                    id = id++,
                    parent = parent,
                    depth = parent.depth + 1,
                    Name = string.IsNullOrWhiteSpace(child.Name) ? child.GetType().Name : $"{child.Name} ({child.GetType().Name})",
                    Status = status,
                    children = new List<TreeViewItem>()
                };

                this._subscription &= status.Status.OnValue(_ => this.Repaint());

                foreach ((IBehaviorTree subTree, StatusTracer statusTracer) in child.SubTreeStatuses)
                {
                    if (subTree?.IsEnabledBranch.Value == true)
                    {
                        item.children.Add(this.BuildTree(item, subTree, ref id, statusTracer));
                    }
                }

                return item;
            }

            protected override void RowGUI(RowGUIArgs args)
            {
                var item = (DebuggerTreeViewItem) args.item;

                Color contentColor = GUI.contentColor;
                Status status = item.Status.Status.Value;
                GUI.contentColor = this.ParentStopped(item)
                    ? Color.grey
                    : status switch
                    {
                        Status.Running => Color.yellow,
                        Status.Failure => new Color(0.5f, 0, 0),
                        Status.Success => new Color(0, 0.5f, 0),
                        Status.Exception => Color.red,
                        _ => Color.grey
                    };
                item.displayName = status switch
                {
                    Status.Failure => $"{item.Name} [fail]",
                    Status.Success => $"{item.Name} [success]",
                    Status.Aborted => $"{item.Name} [aborted]",
                    Status.Exception => $"{item.Name} [EXCEPTION]",
                    _ => item.Name
                };

                if (item.Status.BreakPointSet)
                {
                    item.icon = item.Status.BreakPointHit ? this._brokenButton : this._breakButton;
                }

                base.RowGUI(args);
                GUI.contentColor = contentColor;
            }

            private bool ParentStopped(DebuggerTreeViewItem item)
            {
                return item.parent is DebuggerTreeViewItem parent && (parent.Status.Status.Value is Status.NotRunning or Status.Aborted || this.ParentStopped(parent));
            }

            private class DebuggerTreeViewItem : TreeViewItem
            {
                public string Name;
                public StatusTracer Status;
            }
        }
#else
        private void OnGUI()
        {
            EditorGUILayout.HelpBox(
                "Async Behavior Tree Debugger is currently disabled. Enable it by adding ABT_DEBUG in Scripting Define Symbols under Project Settings > Player > Other Settings for the selected platform.",
                MessageType.Warning);
        }
#endif
    }
}