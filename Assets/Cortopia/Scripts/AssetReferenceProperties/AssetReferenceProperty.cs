using Cortopia.Scripts.Reactivity;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Cortopia.Scripts.AssetReferenceProperties
{
    public class AssetReferenceProperty<T> : MonoBehaviour
    {
        public AssetReference assetReference;
        public string propertyName;
        public T defaultValue;

        public Reactive<T> Value => Reactive.Constant(default(T));

        public void TrySetValue(T value)
        {
        }
    }
}