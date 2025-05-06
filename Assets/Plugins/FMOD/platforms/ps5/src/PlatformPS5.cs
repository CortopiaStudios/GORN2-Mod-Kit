using System;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

#if UNITY_PS5 && !UNITY_EDITOR
namespace FMOD
{
    public partial class VERSION
    {
        public const string dll = "libfmod" + dllSuffix;
    }
}

namespace FMOD.Studio
{
    public partial class STUDIO_VERSION
    {
        public const string dll = "libfmodstudio" + dllSuffix;
    }
}
#endif

namespace FMODUnity
{
#if UNITY_EDITOR
    [InitializeOnLoad]
#endif
    public class PlatformPS5 : Platform
    {
        static PlatformPS5()
        {
            Settings.AddPlatformTemplate<PlatformPS5>("3f3720f8ed41ae540a551deb6ae57973");
        }

        internal override string DisplayName { get { return "PS5"; } }
        internal override void DeclareRuntimePlatforms(Settings settings)
        {
#if UNITY_PS5
            settings.DeclareRuntimePlatform(RuntimePlatform.PS5, this);
#endif
        }

#if UNITY_EDITOR
        internal override IEnumerable<BuildTarget> GetBuildTargets()
        {
#if UNITY_PS5
            yield return BuildTarget.PS5;
#else
            yield return BuildTarget.NoTarget;
#endif
        }

        internal override Legacy.Platform LegacyIdentifier { get { return Legacy.Platform.Reserved_1; } }

        protected override BinaryAssetFolderInfo GetBinaryAssetFolder(BuildTarget buildTarget)
        {
            // This platform didn't actually exist in 1.10 - we're just using path_1_10
            // to handle the fact that the folder name was changed halfway through 2.0.
            return new BinaryAssetFolderInfo("ps5", "Plugins/FMOD/lib/pentagon");
        }

        protected override IEnumerable<FileRecord> GetBinaryFiles(BuildTarget buildTarget, bool allVariants, string suffix)
        {
            yield return new FileRecord(string.Format("libfmod{0}.prx", suffix));
            yield return new FileRecord(string.Format("libfmodstudio{0}.prx", suffix));
        }

        protected override IEnumerable<FileRecord> GetOptionalBinaryFiles(BuildTarget buildTarget, bool allVariants)
        {
            yield return new FileRecord("libresonanceaudio.prx");
        }

        protected override IEnumerable<FileRecord> GetSourceFiles()
        {
            yield return new FileRecord("fmod_ps5.cs");
        }

        protected override IEnumerable<string> GetObsoleteFiles()
        {
            // resonanceaudio.prx
            yield return "lib/pentagon/resonanceaudio.prx";
            yield return "lib/ps5/resonanceaudio.prx";

            // fmod_pentagon.cs
            yield return "src/Runtime/wrapper/fmod_pentagon.cs";
            yield return "platforms/ps5/src/fmod_pentagon.cs";
        }
#endif

        internal override string GetPluginPath(string pluginName)
        {
            return string.Format("{0}/lib{1}.prx", GetPluginBasePath(), pluginName);
        }

#if UNITY_EDITOR
        internal override OutputType[] ValidOutputTypes
        {
            get
            {
                return sValidOutputTypes;
            }
        }

        private static OutputType[] sValidOutputTypes = {
           new OutputType() { displayName = "Audio Out", outputType = FMOD.OUTPUTTYPE.AUDIOOUT },
        };

        internal override int CoreCount { get { return 13; } }
#endif

        internal override List<ThreadAffinityGroup> DefaultThreadAffinities { get { return StaticThreadAffinities; } }

        private static List<ThreadAffinityGroup> StaticThreadAffinities = new List<ThreadAffinityGroup>() {
            new ThreadAffinityGroup(ThreadAffinity.Core2, ThreadType.Mixer, ThreadType.Feeder, ThreadType.Record),
            new ThreadAffinityGroup(ThreadAffinity.Core4,
                ThreadType.Studio_Update, ThreadType.Studio_Load_Bank, ThreadType.Studio_Load_Sample),
        };

        internal override List<CodecChannelCount> DefaultCodecChannels { get { return staticCodecChannels; } }

        private static List<CodecChannelCount> staticCodecChannels = new List<CodecChannelCount>()
        {
            new CodecChannelCount { format = CodecType.AT9, channels = 32 },
            new CodecChannelCount { format = CodecType.FADPCM, channels = 0 },
            new CodecChannelCount { format = CodecType.Vorbis, channels = 0 },
        };
    }
}
