#if UNITY_PS5
using System.Runtime.InteropServices;

namespace FMOD
{
    public static class PS5
    {
        public static RESULT AcmConfigure(bool offloadConvolution, bool halfPrecisionFloat)
        {
            return FMOD_PS5_AcmConfigure(offloadConvolution, halfPrecisionFloat);
        }
        public static RESULT AjmConfigure(int expandedMemorySize)
        {
            return FMOD_PS5_AjmConfigure(expandedMemorySize);
        }
        public static RESULT AT9Configure(bool enable)
        {
            return FMOD_PS5_AT9Configure(enable);
        }

#region importfunctions
        [DllImport(VERSION.dll)]
        private static extern RESULT FMOD_PS5_AcmConfigure(bool offloadConvolution, bool halfPrecisionFloat);
        [DllImport(VERSION.dll)]
        private static extern RESULT FMOD_PS5_AjmConfigure(int expandedMemorySize);
        [DllImport(VERSION.dll)]
        private static extern RESULT FMOD_PS5_AT9Configure(bool enable);
#endregion
    }
}
#endif

