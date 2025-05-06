// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using Cysharp.Threading.Tasks;

namespace Cortopia.Scripts.AI.ABT.Nodes
{
    public class BtRepeater : BtDecorator
    {
        public enum Mode
        {
            /// <summary>
            ///     Keep repeating as long as the child returns false. Return true as soon as the child returns true.
            /// </summary>
            RepeatOnFail,
            /// <summary>
            ///     Keep repeating as long as the child returns true. Return false as soon as the child returns false.
            /// </summary>
            RepeatOnSuccess,
            /// <summary>
            ///     Keep repeating forever (or at least until parent cancels this). There is no result.
            /// </summary>
            RepeatOnComplete
        }

        private readonly int? _count;
        private readonly Mode _mode;

        public BtRepeater(string name, Mode mode, int? count) : base(name)
        {
            this._mode = mode;
            this._count = count;
        }

        public BtRepeater(string name, Mode mode) : base(name)
        {
            this._mode = mode;
        }

        public BtRepeater(string name) : base(name)
        {
            this._mode = Mode.RepeatOnSuccess;
        }

        public override async UniTask<bool> Run(ResettableCancellation.Token cancellationToken)
        {
            int? count = this._count;
            while ((count ?? 1) > 0)
            {
                bool res = await this.RunSubtree(cancellationToken);
                cancellationToken.ThrowIfCancellationRequested();

                switch (this._mode)
                {
                    case Mode.RepeatOnSuccess when !res:
                        return false;
                    case Mode.RepeatOnFail when res:
                        return true;
                }

                count--;
                await UniTask.NextFrame();
                cancellationToken.ThrowIfCancellationRequested();
            }

            return this._mode != Mode.RepeatOnFail;
        }
    }
}