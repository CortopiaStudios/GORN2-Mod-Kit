// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using UnityEditor;
using UnityEngine;

namespace Cortopia.Scripts.Utils
{
    public class BoneID : MonoBehaviour
    {
        public enum Id
        {
            Reference,
            Hips,
            Spine,
            Spine1,
            Spine2,
            Neck,
            Head,
            LeftLip,
            LeftUpperLip,
            MiddleUpperLip,
            Jaw,
            LeftLowerLip,
            MiddleLowerLip,
            RightLowerLip,
            LeftEye,
            LeftUpperLid,
            LeftLowerLid,
            LeftCheek,
            LeftEyeBrowInner,
            LeftEyeBrowMiddle,
            LeftEyeBrowOuter,
            RightEye,
            RightLowerLid,
            RightUpperLid,
            RightCheek,
            RightLip,
            RightUpperLip,
            RightEyeBrowOuter,
            RightEyeBrowMiddle,
            RightEyeBrowInner,
            LeftShoulder,
            LeftArm,
            LeftForeArm,
            LeftHand,
            LeftHandMiddle1,
            LeftHandMiddle2,
            LeftHandMiddle3,
            LeftHandThumb1,
            LeftHandThumb2,
            LeftHandThumb3,
            LeftHandProp,
            LeftForeArmRoll,
            LeftArmRoll,
            RightShoulder,
            RightArm,
            RightForeArm,
            RightHand,
            RightHandMiddle1,
            RightHandMiddle2,
            RightHandMiddle3,
            RightHandThumb1,
            RightHandThumb2,
            RightHandThumb3,
            RightHandProp,
            RightForeArmRoll,
            RightArmRoll,
            LeftUpLeg,
            LeftLeg,
            LeftLegRoll,
            LeftFoot,
            LeftToeBase,
            LeftToe,
            LeftUpLegRoll,
            RightUpLeg,
            RightLeg,
            RightLegRoll,
            RightFoot,
            RightToeBase,
            RightToe,
            RightUpLegRoll,
            Joint0,
            Joint1,
            Joint2,
            Joint3,
            Joint4,
            Joint5,
            Joint6,
            Joint7,
            Joint8,
            Joint9,
            Joint10,
            Joint11,
            Joint12,
            Joint13,
            Joint14,
            Joint15,
            Joint16,
            Joint17,
            Joint18,
            Joint19,
            Count
        }

        [SerializeField]
        private Id id;

        private void OnEnable()
        {
            throw new NotImplementedException();
        }

        private void OnDisable()
        {
            throw new NotImplementedException();
        }

#if UNITY_EDITOR
        [MenuItem("CONTEXT/SkinnedMeshRenderer/Log skinned mesh renderer bones", true)]
        private static bool ValidateLogSmrBones()
        {
            var go = Selection.activeObject as GameObject;
            return go && go.GetComponent<SkinnedMeshRenderer>();
        }

        [MenuItem("CONTEXT/SkinnedMeshRenderer/Add bone ID's to skinned mesh renderer bones", true)]
        private static bool ValidateAutoAddBoneIDs()
        {
            var go = Selection.activeObject as GameObject;
            return go && go.GetComponent<SkinnedMeshRenderer>();
        }
#endif
    }
}