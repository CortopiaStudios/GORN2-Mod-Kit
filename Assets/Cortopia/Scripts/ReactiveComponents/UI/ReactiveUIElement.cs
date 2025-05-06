// Copyright (c) Cortopia Studios. All rights reserved.
// This unpublished material is proprietary to Cortopia Studios.
// The methods and techniques described herein are considered trade secrets
// and/or confidential. Reproduction or distribution, in whole or in part, is
// forbidden except by express written permission of Cortopia Studios.

using System;
using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Cortopia.Scripts.ReactiveComponents.UI
{
    public class ReactiveUIElement : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler, ISelectHandler, IDeselectHandler
    {
        public Reactive<bool> IsSelected => default;

        public Reactive<bool> IsHovered => default;

        public void OnDeselect(BaseEventData eventData)
        {
            throw new NotImplementedException();
        }

        public void OnPointerEnter(PointerEventData eventData)
        {
            throw new NotImplementedException();
        }

        public void OnPointerExit(PointerEventData eventData)
        {
            throw new NotImplementedException();
        }

        public void OnSelect(BaseEventData eventData)
        {
            throw new NotImplementedException();
        }
    }
}