// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using Cysharp.Threading.Tasks;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
using static System.Diagnostics.Debugger;
#endif

namespace Cortopia.Scripts.AI.ABT
{
    public class StatusTracer
    {
        private readonly ResettableCancellation _forceCancellation = new();
        private readonly ReactiveSource<Status> _status;

        public StatusTracer(Status status = ABT.Status.NotRunning)
        {
            this._status = new ReactiveSource<Status>(status);
        }

        public bool BreakPointSet { get; set; }
        public bool BreakPointHit { get; private set; }

        public Reactive<Status> Status => this._status.Reactive;

        public void ForceStop(bool result)
        {
            if (this._status.Value != ABT.Status.Running || this._forceCancellation.IsCancellationRequested)
            {
                return;
            }

            this._status.Value = result ? ABT.Status.Success : ABT.Status.Failure;
            this._forceCancellation.Cancel();
        }

        public void Reset()
        {
            this._status.Value = ABT.Status.NotRunning;
        }

        public async UniTask<bool> Trace(Func<ResettableCancellation.Token, UniTask<bool>> task, ResettableCancellation.Token cancellationToken)
        {
            this._forceCancellation.Reset();
            this._status.Value = ABT.Status.Running;
#if UNITY_EDITOR
            await this.TryBreak();
#endif
            using ResettableCancellation.Scope linkedScope = cancellationToken.CreateLinkedScope(this._forceCancellation);
            bool res;
            try
            {
                res = await task(linkedScope.CancellationToken);
            }
            catch (OperationCanceledException) when (this._status.Value is not (ABT.Status.Success or ABT.Status.Failure))
            {
                this._status.Value = ABT.Status.Aborted;
                throw;
            }
            catch (Exception e) when (this._status.Value is not (ABT.Status.Success or ABT.Status.Failure))
            {
                Debug.LogException(e);
                this._status.Value = ABT.Status.Exception;
                throw;
            }
            
            if (this._status.Value is ABT.Status.Success or ABT.Status.Failure)
            {
                // In case of ForceStopping:
                return this._status.Value == ABT.Status.Success;
            }

            this._status.Value = res ? ABT.Status.Success : ABT.Status.Failure;
            return res;
        }

#if UNITY_EDITOR
        private async UniTask TryBreak()
        {
            if (this.BreakPointSet)
            {
                Debug.Log("ABT breakpoint hit");
                this.BreakPointHit = true;
                EditorApplication.isPaused = true;
                EditorApplication.pauseStateChanged += this.ResetBroken;
                EditorApplication.playModeStateChanged += this.ResetBroken;
                DoBreak();
                await UniTask.NextFrame(); // Since pause is happening at end of frame 
            }
        }

        private static void DoBreak()
        {
            /////////////////
            //
            // This will break when an ABT node with a breakpoint set in the debugger is run.
            //
            Break();
            //
            /////////////////
        }

        private void ResetBroken(PauseState obj)
        {
            if (obj == PauseState.Unpaused)
            {
                this.ResetBroken();
            }
        }

        private void ResetBroken(PlayModeStateChange obj)
        {
            if (obj == PlayModeStateChange.ExitingPlayMode)
            {
                this.ResetBroken();
            }
        }

        private void ResetBroken()
        {
            this.BreakPointHit = false;
            EditorApplication.pauseStateChanged -= this.ResetBroken;
            EditorApplication.playModeStateChanged -= this.ResetBroken;
        }
#endif
    }
}