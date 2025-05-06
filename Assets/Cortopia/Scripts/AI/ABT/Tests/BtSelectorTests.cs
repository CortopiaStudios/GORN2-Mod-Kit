// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System.Collections;
using Cortopia.Scripts.AI.ABT.Nodes;
using Cysharp.Threading.Tasks;
using NUnit.Framework;
using UnityEngine.TestTools;

namespace Cortopia.Scripts.AI.ABT.Tests
{
    public class BtSelectorTests
    {
        [Test]
        public void BtSelectorRunsFirstChild()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);

            var btSelector = new BtSelector("selector") {nodeA, nodeB, nodeC};
            var task = btSelector.Run(cancellationToken);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);
        }

        [Test]
        public void BtSelectorContinuesWithNextIfChildFails()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);

            var btSelector = new BtSelector("selector") {nodeA, nodeB, nodeC};
            var task = btSelector.Run(cancellationToken);
            nodeA.SetResult(false);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);
        }

        [Test]
        public void BtSelectorCancelsChildIfCancelled()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellation = new ResettableCancellation();

            var btSelector = new BtSelector("selector") {nodeA, nodeB, nodeC};
            var task = btSelector.Run(cancellation.CancellationToken);
            nodeA.SetResult(false);
            cancellation.Cancel();

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeB.IsCancellationRequested, Is.True);
            Assert.That(nodeC.IsRunning, Is.False);

            nodeB.AcknowledgeCancellation();

            Assert.That(task.Status == UniTaskStatus.Canceled);
        }

        [Test]
        public void BtSelectorCanBeRunAfterBeingCancelled()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellation = new ResettableCancellation();

            var btSelector = new BtSelector("selector") {nodeA, nodeB, nodeC};
            var task1 = btSelector.Run(cancellation.CancellationToken);
            nodeA.SetResult(false);
            cancellation.Cancel();
            nodeB.AcknowledgeCancellation();

            Assert.That(task1.Status == UniTaskStatus.Canceled);

            var cancellationToken = default(ResettableCancellation.Token);
            var task2 = btSelector.Run(cancellationToken);

            Assert.That(task2.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);

            nodeA.SetResult(false);

            Assert.That(task2.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);
        }

        [UnityTest]
        public IEnumerator BtSelectorFailsIfAllChildrenFails()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSelector = new BtSelector("selector") {nodeA, nodeB, nodeC};
                var task = btSelector.Run(cancellationToken);
                nodeA.SetResult(false);
                nodeB.SetResult(false);
                nodeC.SetResult(false);

                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(await task, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator BtSelectorSucceedsIfAnyChildSucceeds()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSelector = new BtSelector("selector") {nodeA, nodeB, nodeC};
                var task = btSelector.Run(cancellationToken);
                nodeA.SetResult(false);
                nodeB.SetResult(true);

                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(await task, Is.True);
            });
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSelectorRestartsAndCancelsNextChildNextFrame()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSelector = new BtSelector("selector", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSelector.Run(cancellationToken);
                nodeA.SetResult(false);

                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.True);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);

                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(nodeA.IsRunning, Is.True);
                Assert.That(nodeB.IsCancellationRequested, Is.True);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(task.Status == UniTaskStatus.Pending);
            });
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSelectorDoesNotCancelNextChildNextFrameIfFailsImmediately()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSelector = new BtSelector("selector", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSelector.Run(cancellationToken);
                nodeA.ResetResultWhenFinished = false;
                nodeA.SetResult(false);

                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.True);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);

                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(task.Status == UniTaskStatus.Pending);
            });
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSelectorSucceedsAndCancelsNextChildNextFrameIfSucceedsImmediately()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSelector = new BtSelector("selector", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSelector.Run(cancellationToken);
                nodeA.SetResult(false);
                nodeA.ResetResultWhenFinished = false;
                nodeA.SetResult(true);

                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsCancellationRequested, Is.True);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(task.Status == UniTaskStatus.Pending);

                nodeB.AcknowledgeCancellation();

                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(await task, Is.True);
            });
        }

        [Test]
        public void BtSelectorSkipsDisabledChildren()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);
            nodeA.SetEnabled(false);

            var btSelector = new BtSelector("selector") {nodeA, nodeB, nodeC};
            var task = btSelector.Run(cancellationToken);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSelectorCancelsNextChildrenNextFrameIfChildIsEnabled()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSelector = new BtSelector("selector", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSelector.Run(cancellationToken);

                nodeA.SetEnabled(true);
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.True);
                Assert.That(nodeB.IsCancellationRequested, Is.True);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator NonReevaluatingBtSelectorNeverChecksSkippedChildIfChildIsEnabled()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSelector = new BtSelector("selector") {nodeA, nodeB, nodeC};
                var task = btSelector.Run(cancellationToken);

                nodeA.SetEnabled(true);
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSelectorDoesNotCancelNextChildrenNextFrameIfChildIsEnabledAndFailsImmediately()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSelector = new BtSelector("selector", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSelector.Run(cancellationToken);

                nodeA.SetResult(false);
                nodeA.SetEnabled(true);
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSelectorCancelsNextChildrenNextFrameIfChildIsEnabledAndSucceedsImmediately()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSelector = new BtSelector("selector", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSelector.Run(cancellationToken);

                nodeA.SetResult(true);
                nodeA.SetEnabled(true);
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsCancellationRequested, Is.True);
                Assert.That(nodeC.IsRunning, Is.False);

                nodeB.AcknowledgeCancellation();

                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(await task, Is.True);
            });
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSelectorRestartsLowerPrioTasksAfterCancellingThem()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSelector = new BtSelector("selector", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSelector.Run(cancellationToken);

                nodeA.ResetResultWhenFinished = false;
                nodeA.SetResult(false); // Starts node B
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);

                nodeA.ResetResultWhenFinished = true; // Will make node B cancel on second reevaluate 
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning);
                Assert.That(nodeB.IsRunning);
                Assert.That(nodeB.IsCancellationRequested);
                Assert.That(nodeC.IsRunning, Is.False);

                nodeA.ResetResultWhenFinished = false;
                nodeA.SetResult(false); // Will start node B again
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);
                
                Assert.That(nodeB.IsCancellationRequested); // Still cancelled
                nodeB.AcknowledgeCancellation(); // Previous B is finished 

                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);

                nodeB.SetResult(true);
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);
                
                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(await task, Is.True);
            });
        }
    }
}