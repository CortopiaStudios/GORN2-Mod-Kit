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
    public class BtParallelTests
    {
        [Test]
        public void BtParallelRunsAllChildren()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);

            var btSequence = new BtParallel("parallel") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellationToken);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning);
            Assert.That(nodeC.IsCancellationRequested, Is.False);
        }

        [Test]
        public void BtParallelDoesNotAbortOthersOnChildSuccess()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);

            var btSequence = new BtParallel("parallel") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellationToken);

            nodeB.SetResult(true);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning, Is.False);
            Assert.That(nodeC.IsRunning);
            Assert.That(nodeC.IsCancellationRequested, Is.False);
        }

        [UnityTest]
        public IEnumerator BtParallelAbortOthersOnChildFailAndFails()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSequence = new BtParallel("parallel") {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeB.SetResult(false);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning);
                Assert.That(nodeA.IsCancellationRequested, Is.True);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning);
                Assert.That(nodeC.IsCancellationRequested, Is.True);

                nodeA.AcknowledgeCancellation();
                nodeC.AcknowledgeCancellation();
                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(await task, Is.False);
            });
        }

        [Test]
        public void AbortOnSuccessBtParallelDoesNotAbortOthersOnChildFail()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);

            var btSequence = new BtParallel("parallel", BtParallel.Mode.AbortOnSuccess) {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellationToken);

            nodeB.SetResult(false);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning, Is.False);
            Assert.That(nodeC.IsRunning);
            Assert.That(nodeC.IsCancellationRequested, Is.False);
        }

        [UnityTest]
        public IEnumerator AbortOnSuccessBtParallelAbortOthersOnChildSuccessAndSucceeds()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSequence = new BtParallel("parallel", BtParallel.Mode.AbortOnSuccess) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeB.SetResult(true);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning);
                Assert.That(nodeA.IsCancellationRequested, Is.True);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning);
                Assert.That(nodeC.IsCancellationRequested, Is.True);

                nodeA.AcknowledgeCancellation();
                nodeC.AcknowledgeCancellation();
                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(await task, Is.True);
            });
        }

        [UnityTest]
        public IEnumerator AbortOnCompleteBtParallelAbortOthersOnChildSuccessAndSucceeds()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSequence = new BtParallel("parallel", BtParallel.Mode.AbortOnComplete) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeB.SetResult(true);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning);
                Assert.That(nodeA.IsCancellationRequested, Is.True);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning);
                Assert.That(nodeC.IsCancellationRequested, Is.True);

                nodeA.AcknowledgeCancellation();
                nodeC.AcknowledgeCancellation();
                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(await task, Is.True);
            });
        }

        [UnityTest]
        public IEnumerator AbortOnCompleteBtParallelAbortOthersOnChildFailAndFails()
        {
            return UniTask.ToCoroutine(async () =>
            {
                var nodeA = new BtTestNode();
                var nodeB = new BtTestNode();
                var nodeC = new BtTestNode();
                var cancellationToken = default(ResettableCancellation.Token);

                var btSequence = new BtParallel("parallel", BtParallel.Mode.AbortOnComplete) {nodeA, nodeB, nodeC};
                var task = btSequence.Run(cancellationToken);

                nodeB.SetResult(false);

                Assert.That(task.Status == UniTaskStatus.Pending);
                Assert.That(nodeA.IsRunning);
                Assert.That(nodeA.IsCancellationRequested, Is.True);
                Assert.That(nodeB.IsRunning, Is.False);
                Assert.That(nodeC.IsRunning);
                Assert.That(nodeC.IsCancellationRequested, Is.True);

                nodeA.AcknowledgeCancellation();
                nodeC.AcknowledgeCancellation();
                Assert.That(task.Status == UniTaskStatus.Succeeded);
                Assert.That(await task, Is.False);
            });
        }

        [Test]
        public void BtParallelCancelsRunningChildrenIfCancelled()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellation = new ResettableCancellation();

            var btSequence = new BtParallel("parallel") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellation.CancellationToken);

            nodeB.SetResult(true);
            cancellation.Cancel();

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.True);
            Assert.That(nodeB.IsRunning, Is.False);
            Assert.That(nodeC.IsRunning);
            Assert.That(nodeC.IsCancellationRequested, Is.True);

            nodeA.AcknowledgeCancellation();
            nodeC.AcknowledgeCancellation();

            Assert.That(task.Status == UniTaskStatus.Canceled);
        }

        [Test]
        public void BtParallelCanBeRunAfterBeingCancelled()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellation = new ResettableCancellation();

            var btSequence = new BtParallel("parallel") {nodeA, nodeB, nodeC};
            var task1 = btSequence.Run(cancellation.CancellationToken);

            nodeB.SetResult(true);
            cancellation.Cancel();
            nodeA.AcknowledgeCancellation();
            nodeC.AcknowledgeCancellation();

            Assert.That(task1.Status == UniTaskStatus.Canceled);

            var cancellationToken = default(ResettableCancellation.Token);
            var task2 = btSequence.Run(cancellationToken);

            Assert.That(task2.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning);
            Assert.That(nodeC.IsCancellationRequested, Is.False);

            nodeB.SetResult(true);

            Assert.That(task2.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning, Is.False);
            Assert.That(nodeC.IsRunning);
            Assert.That(nodeC.IsCancellationRequested, Is.False);
        }

        [Test]
        public void BtParallelSkipsDisabledChildren()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);
            nodeB.SetEnabled(false);

            var btSequence = new BtParallel("parallel") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellationToken);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning, Is.False);
            Assert.That(nodeC.IsRunning);
            Assert.That(nodeC.IsCancellationRequested, Is.False);
        }

        [Test]
        public void BtParallelSkipsChildrenThatAreDisabledAfterStarting()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);

            var btSequence = new BtParallel("parallel") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellationToken);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeC.IsRunning);

            nodeB.SetEnabled(false);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsCancellationRequested, Is.True);
            Assert.That(nodeC.IsCancellationRequested, Is.False);

            nodeB.AcknowledgeCancellation();

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning, Is.False);
            Assert.That(nodeC.IsRunning);
            Assert.That(nodeC.IsCancellationRequested, Is.False);
        }

        [Test]
        public void BtParallelRunsEnabledChildrenNextFrameWhenEnabled()
        {
            var nodeA = new BtTestNode();
            var nodeB = new BtTestNode();
            var nodeC = new BtTestNode();
            var cancellationToken = default(ResettableCancellation.Token);
            nodeB.SetEnabled(false);

            var btSequence = new BtParallel("parallel") {nodeA, nodeB, nodeC};
            var task = btSequence.Run(cancellationToken);

            nodeB.SetEnabled(true);

            Assert.That(task.Status == UniTaskStatus.Pending);
            Assert.That(nodeA.IsRunning);
            Assert.That(nodeA.IsCancellationRequested, Is.False);
            Assert.That(nodeB.IsRunning);
            Assert.That(nodeB.IsCancellationRequested, Is.False);
            Assert.That(nodeC.IsRunning);
            Assert.That(nodeC.IsCancellationRequested, Is.False);
        }
    }
}