require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe ProgressParser do

  before do
    @listener = Object.new
    @parser = ProgressParser.new(@listener)
  end
  
  it "should return correct percentage for output with only percent" do
    percent_io = StringIO.new percent_string
    @listener.should_receive(:progress_report).with(0.01)
    @listener.should_receive(:progress_report).with(0.05)
    @listener.should_receive(:progress_report).with(0.07)
    @listener.should_receive(:progress_report).with(0.1)
    @parser.parse(percent_io)
  end

  it "should return correct percentage for output with only time" do
    time_io = StringIO.new time_string
    @listener.should_receive(:progress_report).with(0.1)
    @listener.should_receive(:progress_report).with(0.15)
    @parser.parse(time_io)
  end

  it "should return correct percentage for output with only time and unusual line terminators" do
    time_io_with_newlines = StringIO.new time_string_with_mixed_eol_chars
    @listener.should_receive(:progress_report).with(0.1)
    @listener.should_receive(:progress_report).with(0.15)
    @parser.parse(time_io_with_newlines)
  end

  def percent_string
    """
MP3 audio selected.
Building audio filter chain for 48000Hz/2ch/s16le -> 22050Hz/2ch/s16le...
[dummy] Was reinitialized: 22050Hz/2ch/s16le
[dummy] Was reinitialized: 22050Hz/2ch/s16le
[libaf] Reallocating memory in module lavcresample, old len = 0, new len = 2308
XXX initial  v_pts=0.000  a_pos=12000 (0.500)
[ffmpeg] aspect_ratio: 1.333333
VDec: vo config request - 512 x 384 (preferred colorspace: Planar YV12)
Trying filter chain: scale expand lavc
VDec: using Planar YV12 as output csp (no 0)
Movie-Aspect is 1.33:1 - prescaling to correct movie aspect.
VO Config (512x384->512x384,flags=0,'MPlayer',0x32315659)
SwScaler: reducing / aligning filtersize 5 -> 4
SwScaler: reducing / aligning filtersize 5 -> 4
SwScaler: reducing / aligning filtersize 5 -> 4
SwScaler: reducing / aligning filtersize 5 -> 4
============================================================
SwScaler: BICUBIC scaler, from yuv420p to yuv420p using MMX2
SwScaler: using 4-tap MMX scaler for horizontal luminance scaling
SwScaler: using 4-tap MMX scaler for horizontal chrominance scaling
SwScaler: using n-tap MMX scaler for vertical scaling (YV12 like)
SwScaler: 512x384 -> 640x480
REQ: flags=0x401  req=0x0
REQ: flags=0x401  req=0x0
videocodec: lib²avcodec (640x480 fourcc=766c66 [flv])
[VE_LAVC] High quality encoding selected (non-realtime)!
*** [lavc] Allocating mp_image_t, 640x480x12bpp YUV planar, 460800 bytes
*** [expand] Direct Rendering mp_image_t, 640x480x12bpp YUV planar, 460800 bytes
*** [scale] Allocating (slices) mp_image_t, 512x384x12bpp YUV planar, 294912 bytes
*** [scale] Allocating (slices) mp_image_t, 512x384x12bpp YUV planar, 294912 bytes/S 0/1/0
Muxer frame buffer sending 21 frame(s) to the muxer.
VIDEO CODEC ID: 0
AUDIO CODEC ID: 15001, TAG: 0
MUXER_LAVF(audio stream) frame_size: 576, scale: 576, sps: 22050, rate: 22050, ctx->block_align = stream->wf->nBlockAlign; 0=576 stream->wf->nAvgBytesPerSec:8121
Writing header...

1 duplicate frame(s)!
*** [scale] Allocating (slices) mp_image_t, 512x384x12bpp YUV planar, 294912 bytes/S 1/1/0
Pos:   0.8s     21f ( 1%)   0fps Trem:   0min   5mb  A-V:0.083 [0:65] A/Vms 0/18 D/B/S 1/1/0
Skipping frame!
Pos:   2.8s     70f ( 5%)  39fps Trem:   0min   4mb  A-V:0.011 [718:64] A/Vms 0/20 D/B/S 1/2/1
1 duplicate frame(s)!
Pos:   3.7s     93f ( 7%)  39fps Trem:   0min   4mb  A-V:0.012 [669:64] A/Vms 0/21 D/B/S 2/2/1
1 duplicate frame(s)!
Pos:   4.7s    117f (10%)  41fps Trem:   0min   3mb  A-V:0.017 [631:64] A/Vms 0/20 D/B/S 3/2/1
""".gsub("\n", "\r")
  end

  def time_string
    """
MOV:     Syncing samples (keyframes) table! (124 entries) (ver:0,flags:0)
MOV: unknown chunk: stps 12
MOV: unknown chunk: sdtp 5971
MOV:     Sample->Chunk mapping table!  (995 blocks) (ver:0,flags:0)
MOV:     Sample size table! (entries=5967 ss=0) (ver:0,flags:0)
MOV:     Chunk offset table! (995 chunks)
MOV track #1: 995 chunks, 5967 samples
pts=149176  scale=600  time=100.0
EL#0: pts=0  1st_sample=0  frames=5967 (248.627s)  pts_offs=0
==> Found video stream: 1
MOV: Found unknown movie atom colr (18)!
MOV: AVC decoder configuration record atom (44)!
MOV: avcC version: 1
MOV: avcC profile: 77
MOV: avcC profile compatibility: 64
MOV: avcC level: 41
MOV: avcC nal length size: 4
MOV: avcC number of sequence param sets: 1
MOV: avcC sps 0 have length 21
MOV: avcC number of picture param sets: 1
MOV: avcC pps 0 have length 4
Image size: 1920 x 1080 (24 bpp)
Display size: 1920 x 1080
Fourcc: avc1  Codec: 'H.264'
--------------
Quicktime Clip Info:
 Author: Maria Taylor
 Comment: All Rights Reserved
 Copyright: ©2005 Saddle Creek Records
 Name: Song Beneath The Song
MOV: unknown chunk: meta 376
MOV: longest streams: A: #0 (11655 samples)  V: #1 (5967 samples)
VIDEO:  [avc1]  1920x1080  24bpp  15.385 fps    0.0 kbps ( 0.0 kbyte/s)
[V] filefmt:7  fourcc:0x31637661  size:1920x1080  fps:15.38  ftime:=0.0650
==========================================================================
Opening audio decoder: [faad] AAC (MPEG2/4 Advanced Audio Coding)
dec_audio: Allocating 4608 bytes for input buffer.
dec_audio: Allocating 49152 + 65536 = 114688 bytes for output buffer.
FAAD: Decoder init done (0Bytes)!
FAAD: Negotiated samplerate: 48000Hz  channels: 2
FAAD: got 128kbit/s bitrate from MP4 header!
AUDIO: 48000 Hz, 2 ch, s16le, 128.0 kbit/8.33% (ratio: 16000->192000)
Selected audio codec: [faad] afm: faad (FAAD AAC (MPEG-2/MPEG-4 Audio) decoder)
==========================================================================
OK, exit
ALLOCATED STREAM N. 1, type=0
Opening video filter: [expand osd=1]
Expand: -1 x -1, -1 ; -1, osd: 1, aspect: 0.000000, round: 1
Opening video filter: [scale w=640 h=480]
SwScale params: 640 x 480 (-1=no scaling)
==========================================================================
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
INFO: libavcodec init OK!
Selected video codec: [ffh264] vfm: ffmpeg (FFmpeg H.264)
==========================================================================
ALLOCATED STREAM N. 2, type=1
Building audio filter chain for 48000Hz/2ch/s16le -> 22050Hz/0ch/??...
[libaf] Adding filter dummy
[dummy] Was reinitialized: 48000Hz/2ch/s16le
[libaf] Adding filter lavcresample
[dummy] Was reinitialized: 22050Hz/2ch/s16le
[dummy] Was reinitialized: 22050Hz/2ch/s16le
Building audio filter chain for 48000Hz/2ch/s16le -> 22050Hz/2ch/s16le...
[dummy] Was reinitialized: 22050Hz/2ch/s16le
[dummy] Was reinitialized: 22050Hz/2ch/s16le
[libaf] Reallocating memory in module lavcresample, old len = 0, new len = 2308
[ffmpeg] aspect_ratio: 0.000000
VDec: vo config request - 1920 x 1080 (preferred colorspace: Planar YV12)
Trying filter chain: scale expand lavc
VDec: using Planar YV12 as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
VO Config (1920x1080->1920x1080,flags=0,'MPlayer',0x32315659)
REQ: flags=0x401  req=0x0
REQ: flags=0x401  req=0x0
videocodec: libavcodec (640x480 fourcc=766c66 [flv])
[VE_LAVC] High quality encoding selected (non-realtime)!
*** [scale] Exporting mp_image_t, 1920x1080x12bpp YUV planar, 3110400 bytes
*** [lavc] Allocating mp_image_t, 640x480x12bpp YUV planar, 460800 bytes
*** [expand] Direct Rendering mp_image_t, 640x480x12bpp YUV planar, 460800 bytes
Muxer frame buffer sending 21 frame(s) to the muxer.
VIDEO CODEC ID: 0
AUDIO CODEC ID: 15001, TAG: 0
MUXER_LAVF(audio stream) frame_size: 576, scale: 576, sps: 22050, rate: 22050, ctx->block_align = stream->wf->nBlockAlign; 0=576 stream->wf->nAvgBytesPerSec:6272
Writing header...
Pos:   10.0s     50f ( 0%)  21fps Trem:   0min   0mb  A-V:0.043 [875:52] A/Vms 1/42 D/B/S 3/3/1
Writing header...
Pos:   15.0s     50f ( 0%)  21fps Trem:   0min   0mb  A-V:0.043 [875:52] A/Vms 1/42 D/B/S 3/3/1
""".gsub("\n", "\r")
  end

  def time_string_with_mixed_eol_chars
    """
MOV:     Syncing samples (keyframes) table! (124 entries) (ver:0,flags:0)
MOV: unknown chunk: stps 12
MOV: unknown chunk: sdtp 5971
MOV:     Sample->Chunk mapping table!  (995 blocks) (ver:0,flags:0)
MOV:     Sample size table! (entries=5967 ss=0) (ver:0,flags:0)
MOV:     Chunk offset table! (995 chunks)
MOV track #1: 995 chunks, 5967 samples
pts=149176  scale=600  time=100.0
EL#0: pts=0  1st_sample=0  frames=5967 (248.627s)  pts_offs=0
==> Found video stream: 1
MOV: Found unknown movie atom colr (18)!
MOV: AVC decoder configuration record atom (44)!
MOV: avcC version: 1
MOV: avcC profile: 77
MOV: avcC profile compatibility: 64
MOV: avcC level: 41
MOV: avcC nal length size: 4
MOV: avcC number of sequence param sets: 1
MOV: avcC sps 0 have length 21
MOV: avcC number of picture param sets: 1
MOV: avcC pps 0 have length 4
Image size: 1920 x 1080 (24 bpp)
Display size: 1920 x 1080
Fourcc: avc1  Codec: 'H.264'
--------------
Quicktime Clip Info:
 Author: Maria Taylor
 Comment: All Rights Reserved
 Copyright: ©2005 Saddle Creek Records
 Name: Song Beneath The Song
MOV: unknown chunk: meta 376
MOV: longest streams: A: #0 (11655 samples)  V: #1 (5967 samples)
VIDEO:  [avc1]  1920x1080  24bpp  15.385 fps    0.0 kbps ( 0.0 kbyte/s)
[V] filefmt:7  fourcc:0x31637661  size:1920x1080  fps:15.38  ftime:=0.0650
==========================================================================
Opening audio decoder: [faad] AAC (MPEG2/4 Advanced Audio Coding)
dec_audio: Allocating 4608 bytes for input buffer.
dec_audio: Allocating 49152 + 65536 = 114688 bytes for output buffer.
FAAD: Decoder init done (0Bytes)!
FAAD: Negotiated samplerate: 48000Hz  channels: 2
FAAD: got 128kbit/s bitrate from MP4 header!
AUDIO: 48000 Hz, 2 ch, s16le, 128.0 kbit/8.33% (ratio: 16000->192000)
Selected audio codec: [faad] afm: faad (FAAD AAC (MPEG-2/MPEG-4 Audio) decoder)
==========================================================================
OK, exit
ALLOCATED STREAM N. 1, type=0
Opening video filter: [expand osd=1]
Expand: -1 x -1, -1 ; -1, osd: 1, aspect: 0.000000, round: 1
Opening video filter: [scale w=640 h=480]
SwScale params: 640 x 480 (-1=no scaling)
==========================================================================
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
INFO: libavcodec init OK!
Selected video codec: [ffh264] vfm: ffmpeg (FFmpeg H.264)
==========================================================================
""" + """
ALLOCATED STREAM N. 2, type=1
Building audio filter chain for 48000Hz/2ch/s16le -> 22050Hz/0ch/??...
[libaf] Adding filter dummy
[dummy] Was reinitialized: 48000Hz/2ch/s16le
[libaf] Adding filter lavcresample
[dummy] Was reinitialized: 22050Hz/2ch/s16le
[dummy] Was reinitialized: 22050Hz/2ch/s16le
Building audio filter chain for 48000Hz/2ch/s16le -> 22050Hz/2ch/s16le...
[dummy] Was reinitialized: 22050Hz/2ch/s16le
[dummy] Was reinitialized: 22050Hz/2ch/s16le
[libaf] Reallocating memory in module lavcresample, old len = 0, new len = 2308
[ffmpeg] aspect_ratio: 0.000000
VDec: vo config request - 1920 x 1080 (preferred colorspace: Planar YV12)
Trying filter chain: scale expand lavc
VDec: using Planar YV12 as output csp (no 0)
Movie-Aspect is undefined - no prescaling applied.
VO Config (1920x1080->1920x1080,flags=0,'MPlayer',0x32315659)
REQ: flags=0x401  req=0x0
REQ: flags=0x401  req=0x0
videocodec: libavcodec (640x480 fourcc=766c66 [flv])
[VE_LAVC] High quality encoding selected (non-realtime)!
*** [scale] Exporting mp_image_t, 1920x1080x12bpp YUV planar, 3110400 bytes
*** [lavc] Allocating mp_image_t, 640x480x12bpp YUV planar, 460800 bytes
*** [expand] Direct Rendering mp_image_t, 640x480x12bpp YUV planar, 460800 bytes
Muxer frame buffer sending 21 frame(s) to the muxer.
VIDEO CODEC ID: 0
AUDIO CODEC ID: 15001, TAG: 0
MUXER_LAVF(audio stream) frame_size: 576, scale: 576, sps: 22050, rate: 22050, ctx->block_align = stream->wf->nBlockAlign; 0=576 stream->wf->nAvgBytesPerSec:6272
Writing header...
Pos:   10.0s     50f ( 0%)  21fps Trem:   0min   0mb  A-V:0.043 [875:52] A/Vms 1/42 D/B/S 3/3/1
Writing header...
Pos:   15.0s     50f ( 0%)  21fps Trem:   0min   0mb  A-V:0.043 [875:52] A/Vms 1/42 D/B/S 3/3/1
""".gsub("\n", "\r")
  end

end