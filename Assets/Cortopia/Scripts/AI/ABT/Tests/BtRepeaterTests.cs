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
    public class BtRepeaterTests
    {
        [Test]
        public void BtRepeaterRunsFirstEnabledChild()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);
            nodeA.SetEnabled(false);

            var btSequence = new BtRepeater("repeater") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellationToken);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);
        }

        [UnityTest]
        public IEnumerator BtRepeaterRepeatsNextFrameIfChildSucceeds()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtRepeater("repeater") {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeB.SetResult(true);

                await UniTask.NextFrame();
                await UniTask.NextFrame();

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator BtRepeaterFailsIfChildFails()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtRepeater("repeater") {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeB.SetResult(false);

                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(await task, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator RepeatOnFailBtRepeaterRepeatsNextFrameIfChildFails()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtRepeater("repeater", BtRepeater.Mode.RepeatOnFail) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeB.SetResult(false);

                await UniTask.NextFrame();
                await UniTask.NextFrame();

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator RepeatOnFailBtRepeaterSucceedsIfChildSucceeds()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtRepeater("repeater", BtRepeater.Mode.RepeatOnFail) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeB.SetResult(true);

                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
                Assert.That(await task, Is.True);
            });
        }

        [UnityTest]
        public IEnumerator RepeatOnCompleteBtRepeaterRepeatsNextFrameIfChildSucceeds()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtRepeater("repeater", BtRepeater.Mode.RepeatOnComplete) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeB.SetResult(true);

                await UniTask.NextFrame();
                await UniTask.NextFrame();

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator RepeatOnCompleteBtRepeaterRepeatsNextFrameIfChildFails()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtRepeater("repeater", BtRepeater.Mode.RepeatOnComplete) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeB.SetResult(false);

                await UniTask.NextFrame();
                await UniTask.NextFrame();

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [UnityTest]
        public IEnumerator BtRepeaterRunsEarlierChildNextFrameIfEnabledWhenRepeating()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);
                nodeA.SetEnabled(false);

                var btSequence = new BtRepeater("repeater") {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeA.SetEnabled(true);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning, Is.False);
                Assert.That(nodeB.IsRunning);
                Assert.That(nodeB.IsCancellationRequested, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);

                nodeB.SetResult(true);

                await UniTask.NextFrame();
                await UniTask.NextFrame();

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning);
                Assert.That(nodeA.IsCancellationRequested, Is.False);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning, Is.False);
            });
        }

        [Test]
        public void BtRepeaterCancelsRunningChildIfCancelled()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellation = new ResettableCancellation();
            nodeA.SetEnabled(false);

            var btSequence = new BtRepeater("repeater", BtRepeater.Mode.RepeatOnComplete) {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellation.CancellationToken);

            cancellation.Cancel();

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeB.IsCancellationRequested, Is.True);
            Assert.That(nodeC.IsRunning, Is.False);

            nodeB.AcknowledgeCancellation();

            Assert.That(task.Status == UniTaskStatus.Canceled);
        }

        [Test]
        public void BtRepeaterCanBeRunAfterBeingCancelled()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellation = new ResettableCancellation();
            nodeA.SetEnabled(false);

            var btSequence = new BtRepeater("repeater", BtRepeater.Mode.RepeatOnComplete) {nodeA, nodeB, nodeC};
            var task1 = btSequence.Run(cancellation.CancellationToken);

            cancellation.Cancel();
            nodeB.AcknowledgeCancellation();

            Assert.That(task1.Status == UniTaskStatus.Canceled);

            var cancellationToken = default(ResettableCancellation.Token);
            var task2 = btSequence.Run(cancellationToken);

            Assert.That(task2.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning, Is.False);
        }
    }
}