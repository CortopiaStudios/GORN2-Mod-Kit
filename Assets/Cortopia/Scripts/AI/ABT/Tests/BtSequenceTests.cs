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
    public class BtSequenceTests
    {
        [Test]
        public void BtSequenceRunsFirstChild()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);

            var btSequence = new BtSequence("sequence") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellationToken);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);
        }

        [Test]
        public void BtSequenceContinuesWithNextIfChildSucceeds()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);

            var btSequence = new BtSequence("sequence") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellationToken);
            nodeA.SetResult(true);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);
        }

        [Test]
        public void BtSequenceCancelsChildIfCancelled()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellation = new ResettableCancellation();

            var btSequence = new BtSequence("sequence") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellation.CancellationToken);
            nodeA.SetResult(true);
            cancellation.Cancel();

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeB.IsCancellationRequested, Is.True);
            Assert.That(nodeC.IsRunning, Is.False);

            nodeB.AcknowledgeCancellation();

            Assert.That(task.Status == UniTaskStatus.Canceled);
        }

        [Test]
        public void BtSequenceCanBeRunAfterBeingCancelled()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellation = new ResettableCancellation();

            var btSequence = new BtSequence("sequence") {nodeA, nodeB, nodeC};
            var task1 = btSequence.Run(cancellation.CancellationToken);
            nodeA.SetResult(true);
            cancellation.Cancel();
            nodeB.AcknowledgeCancellation();

            Assert.That(task1.Status == UniTaskStatus.Canceled);

            var cancellationToken = default(ResettableCancellation.Token);
            var task2 = btSequence.Run(cancellationToken);

            Assert.That(task2.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);

            nodeA.SetResult(true);

            Assert.That(task2.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);
        }

        [UnityTest]
        public IEnumerator BtSequenceSucceedsIfAllChildrenSucceeds()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSequence = new BtSequence("sequence") {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);
                nodeA.SetResult(true);
                nodeB.SetResult(true);
                nodeC.SetResult(true);

                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(await task, Is.True);
            });
        }

        [UnityTest]
        public IEnumerator BtSequenceFailsIfAnyChildFails()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSequence = new BtSequence("sequence") {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);
                nodeA.SetResult(true);
                nodeB.SetResult(false);

                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(await task, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSequenceRestartsAndCancelsNextChildNextFrame()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSequence = new BtSequence("sequence", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);
                nodeA.SetResult(true);

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
        public IEnumerator ReevaluatingBtSequenceDoesNotCancelNextChildNextFrameIfSucceedsImmediately()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSequence = new BtSequence("sequence", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);
                nodeA.ResetResultWhenFinished = false;
                nodeA.SetResult(true);

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
        public IEnumerator ReevaluatingBtSequenceFailsAndCancelsNextChildNextFrameIfFailsImmediately()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSequence = new BtSequence("sequence", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);
                nodeA.SetResult(true);
                nodeA.ResetResultWhenFinished = false;
                nodeA.SetResult(false);

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
                Assert.That(await task, Is.False);
            });
        }

        [Test]
        public void BtSequenceSkipsDisabledChildren()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);
            nodeA.SetEnabled(false);

            var btSequence = new BtSequence("sequence") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellationToken);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSequenceCancelsNextChildrenNextFrameIfChildIsEnabled()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtSequence("sequence", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeA.SetEnabled(true);
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.True);
                Assert.That(nodeB.IsCancellationRequested, Is.True);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator NonReevaluatingBtSequenceNeverChecksSkippedChildIfChildIsEnabled()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtSequence("sequence") {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeA.SetEnabled(true);
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSequenceDoesNotCancelNextChildrenNextFrameIfChildIsEnabledAndSucceedsImmediately()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtSequence("sequence", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeA.SetResult(true);
                nodeA.SetEnabled(true);
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSequenceCancelsNextChildrenNextFrameIfChildIsEnabledAndFailsImmediately()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtSequence("sequence", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeA.SetResult(false);
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
                Assert.That(await task, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator ReevaluatingBtSequenceRestartsLowerPrioTasksAfterCancellingThem()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSequence = new BtSequence("sequence", BtGroup.Mode.KeepReevaluatingHigherSubTrees) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeA.ResetResultWhenFinished = false;
                nodeA.SetResult(true); // Starts node B
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
                nodeA.SetResult(true); // Will start node B again
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(nodeB.IsCancellationRequested); // Still cancelled
                nodeB.AcknowledgeCancellation(); // Previous B is finished 

                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);

                nodeB.SetResult(false);
                await UniTask.NextFrame(PlayerLoopTiming.LastUpdate);

                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(await task, Is.False);
            });
        }
    }
}