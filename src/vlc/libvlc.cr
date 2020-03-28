@[Link("vlc")]
lib LibVlc
    # Note to self: Programm might crash when getting the metadata and printing it as a string
    # --> Cause: the function returns a null Pointer: Pointer.null
    alias Instance = Void*
    alias MediaPlayer = Void*
    alias MediaListPlayer = Void*
    alias Media = Void*
    alias MediaList = Void*
    alias Time = LibC::Int64T
    alias EventManager = Void*
    alias EventType = LibC::Int
    alias Callback = Proc(EventData*, Void*, Nil)
    alias AudioPlayCallback = Proc(Void*, Void*, LibC::UInt, UInt64, Nil)
    alias AudioPauseCallback = Proc(Void*, UInt64, Nil)
    alias AudioResumeCallback = Proc(Void*, UInt64, Nil)
    alias AudioFlushCallback = Proc(Void*, UInt64, Nil)
    alias AudioDrainCallback = Proc(Void*, Nil)
    alias AudioCleanupCallback = Proc(Void*, Nil)
    alias AudioVolumeCallback = Proc(Void*, LibC::Float, Bool, Nil)
    alias AudioSetupCallback = Proc(Void**, LibC::Char*, LibC::UInt, LibC::UInt, Nil)
    alias Picture = Void*
    alias Equalizer = Void*
    alias MediaThumbnailRequest = Void*

    enum State
        NothingSpecial
        Opening
        Buffering
        Playing
        Paused
        Stopped
        Ended
        Error
    end

    enum MediaType
        Unknown
        File
        Directory
        Disc
        Stream
        Playlist
    end

    enum TrackType
        Unknown
        Audio
        Video
        Text
    end

    enum PlaybackMode
        Default
        Loop
        Repeat
    end

    enum Meta
        Title
        Artist = 1
        Genre
        Copyright
        Album
        TrackNumber
        Description
        Rating
        Date
        Setting
        URL
        Language
        NowPlaying
        Publisher
        EncodedBy
        ArtworkURL
        TrackID
        TrackTotal
        Director
        Season
        Episode
        ShowName
        Actors
        AlbumArtist
        DiscNumber
        DiscTotal  
    end

    enum MediaParsedStatus
        Skipped
        Failed
        Timeout
        Done
    end

    enum Event
        MediaMetaChanged = 0
        MediaSubItemAdded
        MediaDurationChanged
        MediaParsedChanged
        MediaFreed
        MediaStateChanged
        MediaSubItemTreeAdded

        MediaPlayerMediaChanged=0x100
        MediaPlayerNothingSpecial
        MediaPlayerOpening
        MediaPlayerBuffering
        MediaPlayerPlaying
        MediaPlayerPaused
        MediaPlayerStopped
        MediaPlayerForward
        MediaPlayerBackward
        MediaPlayerEndReached
        MediaPlayerEncounteredError
        MediaPlayerTimeChanged
        MediaPlayerPositionChanged
        MediaPlayerSeekableChanged
        MediaPlayerPausableChanged
        MediaPlayerTitleChanged
        MediaPlayerSnapshotTaken
        MediaPlayerLengthChanged
        MediaPlayerVout
        MediaPlayerScrambledChanged
        MediaPlayerESAdded
        MediaPlayerESDeleted
        MediaPlayerESSelected
        MediaPlayerCorked
        MediaPlayerUncorked
        MediaPlayerMuted
        MediaPlayerUnmuted
        MediaPlayerAudioVolume
        MediaPlayerAudioDevice
        MediaPlayerChapterChanged

        MediaListItemAdded = 0x200
        MediaListWillAddItem
        MediaListItemDeleted 
        MediaListWillDeleteItem
        MediaListEndReached

        MediaListViewItemAdded = 0x300
        MediaListViewWillAddItem
        MediaListViewItemDeleted
        MediaListViewWillDeleteItem

        MediaListPlayerPlayed = 0x400
        MediaListPlayerNextItemSet
        MediaListPlayerStopped

        MediaDiscovererStarted=0x500
        MediaDiscovererEnded

        RendererDiscovererItemAdded
        RendererDiscovererItemDeleted
    end

    enum PictureType
        Argb
        Png
        Jpg
    end

    enum Role
        None
        Music
        Video
        Communication
        Game
        Notification
        Animation
        Production
        Accessibility
    end

    enum MediaParseFlag
        ParseLocal
        ParseNetwork
        FetchLocal
        FetchNetwork
        DoInteract
    end

    enum SlaveType
        Subtitle
        Audio
    end

    enum ThumbnailSeekSpeed
        Precise
        Fast
    end


    struct MediaStats
        i_read_bytes : LibC::Int
        f_input_bitrate : LibC::Float
        i_demux_read_bytes : LibC::Int
        f_demux_bitrate : LibC::Float
        i_demux_corrupted : LibC::Int
        i_demux_discontinuity : LibC::Int
        i_decoded_video : LibC::Int
        i_decoded_audio : LibC::Int
        i_displayed_pictures : LibC::Int
        i_lost_pictures : LibC::Int
        i_played_abuffers : LibC::Int
        i_lost_abuffers : LibC::Int
    end

    struct EventData
        type : Event
        p_obj : Void*
        new_state : State    # Vars can be read, depending on the event type
        meta_type : Meta
        new_child : Media*
        new_duration : LibC::Int64T
        md : Media*
        p_thumbnail : Picture*
        item : Media*
        new_status : LibC::Int
        new_cache : LibC::Float
        new_chapter : LibC::Int
        new_position : LibC::Float
        new_time : Time
        new_title : LibC::Int
        new_seekable : LibC::Int
        new_pausable : LibC::Int
        new_scrambled : LibC::Int
        new_count : LibC::Int
        index : LibC::Int
        psz_filename : LibC::Char*
        new_length : Time
        new_media : Media*
        i_type : TrackType
        i_id : LibC::Int
        volume : LibC::Float
        device : LibC::Char*
    end

    struct AudioOutput
        psz_name : LibC::Char*
        psz_description : LibC::Char*
        p_next : AudioOutput*
    end

    struct TrackDescription
        i_id : LibC::Int
        psz_name : LibC::Char*
        p_next : TrackDescription*
    end

    struct OutputDevice
        psz_device : LibC::Char*
        psz_description : LibC::Char*
        p_next : OutputDevice*
    end

    struct MediaSlave
        psz_uri : LibC::Char*
        i_type : SlaveType
        i_priority : LibC::UInt
    end

    struct AudioTrack
        channels : LibC::UInt
        rate : LibC::UInt
    end

    struct SubtitleTrack
        psz_encoding : LibC::Char*
    end

    union TrackUnion
        audio : AudioTrack
        subtitle : SubtitleTrack
    end

    struct MediaTrack
        i_codec : LibC::UInt32T
        i_bitrage : LibC::UInt
        psz_language : LibC::Char*
        psz_description : LibC::Char*
        i_original_fourcc : LibC::UInt32T
        i_id : LibC::Int
        i_profile : LibC::Int
        i_level : LibC::Int
        i_type : TrackType
        track : TrackUnion
    end


    # Main and instance
    fun new_instance = libvlc_new(arguments_count: LibC::Int, arguments: LibC::Char*) : Instance*
    fun free = libvlc_free(Void*)
    fun free_instance = libvlc_release(instance: Instance*)
    fun version = libvlc_get_version(): LibC::Char*
    fun compiler_version = libvlc_get_compiler(): LibC::Char*
    
    fun get_audio_outputs = libvlc_audio_output_list_get(instance : Instance*) : AudioOutput*
    fun free_audio_outputs = libvlc_audio_output_list_release(outputs : AudioOutput*) 
    fun set_audio_output = libvlc_audio_output_set(media_player : MediaPlayer*, psz_name : LibC::Char*) : LibC::Int
    
    
    fun get_audio_channel = libvlc_audio_get_channel(media_player : MediaPlayer*) : LibC::Int
    fun get_audio_delay = libvlc_audio_get_delay(media_player : MediaPlayer*) : LibC::Int64T
    fun get_audio_mute = libvlc_audio_get_mute(media_player : MediaPlayer*) : LibC::Int
    fun get_audio_track = libvlc_audio_get_track(media_player : MediaPlayer*) : LibC::Int
    fun get_audio_track_count = libvlc_audio_get_track_count(media_player : MediaPlayer*) : LibC::Int
    fun get_audio_volume = libvlc_audio_get_volume(media_player : MediaPlayer*) : LibC::Int
    fun enum_audio_output_devices = libvlc_audio_output_device_enum(media_player : MediaPlayer*) : OutputDevice*
    fun get_audio_output_device = libvlc_audio_output_device_get(media_player : MediaPlayer*) : LibC::Char*
    fun get_audio_output_devices = libvlc_audio_output_device_list_get(instance : Instance*, audio_out : LibC::Char*) : OutputDevice*
    fun free_audio_output_device = libvlc_audio_output_device_list_release(device : OutputDevice*)
    fun set_audio_output_device = libvlc_audio_output_device_set(media_player : MediaPlayer*, audio_output_module : LibC::Char*, device_id : LibC::Char*)

    fun get_audio_track_description = libvlc_audio_get_track_description(media_player : MediaPlayer*) : TrackDescription*
    fun free_audio_track_description = libvlc_track_description_list_release(description : TrackDescription*)

    fun toggle_audio_mute = libvlc_audio_toggle_mute(media_player : MediaPlayer*)
    fun get_media_player_role = libvlc_media_player_get_role(media_player : MediaPlayer*) : Role
    fun set_media_player_role = libvlc_media_player_set_role(media_player : MediaPlayer*, role : Role) : LibC::Int
    fun set_media_player_equalizer = libvlc_media_player_set_equalizer(media_player : MediaPlayer*, equalizer : Equalizer*) : LibC::Int

    # Equalizer
    fun get_equalizer_amp_at_index = libvlc_audio_equalizer_get_amp_at_index(equalizer : Equalizer*, band : LibC::Int) : LibC::Float
    fun get_equalizer_band_count = libvlc_audio_equalizer_get_band_count() : LibC::Int
    fun get_equalizer_band_frequency = libvlc_audio_equalizer_get_band_frequency(index : LibC::Int) : LibC::Float
    fun get_equalizer_preamp = libvlc_audio_equalizer_get_preamp(equalizer : Equalizer*) : LibC::Float
    fun get_equalizer_preset_count = libvlc_audio_equalizer_get_preset_count() : LibC::Int
    fun get_equalizer_preset_name = libvlc_audio_equalizer_get_preset_name(index : LibC::Int) : LibC::Char*
    
    fun set_equalizer_amp_at_index = libvlc_audio_equalizer_set_amp_at_index(equalizer : Equalizer*, amp : LibC::Float, band : LibC::Int) : LibC::Int # Float needs to be between -20 and 20 (inclusive)
    fun set_equalizer_preamp = libvlc_audio_equalizer_set_preamp(equalizer : Equalizer*, preamp : LibC::Float) : LibC::Int
    fun new_equalizer = libvlc_audio_equalizer_new() : Equalizer*
    fun new_equalizer_from_preset = libvlc_audio_equalizer_new_from_preset(index : LibC::Int) : Equalizer*
    fun free_equalizer = libvlc_audio_equalizer_release(equalizer : Equalizer*)

    # Media
    fun new_media_from_path = libvlc_media_new_path(instance : Instance*, path : LibC::Char*) : Media*
    fun new_media_from_location = libvlc_media_new_location(instance : Instance*, path : LibC::Char*) : Media*
    fun new_media_from_file_descriptor = libvlc_media_new_fd(instance : Instance*, descriptor : LibC::Int) : Media*
    fun free_media = libvlc_media_release(media : Media*)
    fun retain_media = libvlc_media_retain(media : Media*)
    fun duplicate_media = libvlc_media_duplicate(media : Media*) : Media*

    fun get_media_resource_locator = libvlc_media_get_mrl(media : Media*) : LibC::Char*
    fun get_media_duration = libvlc_media_get_duration(media : Media*) : Time
    fun get_media_tracks = libvlc_media_tracks_get(media : Media*, tracks : MediaTrack***) : LibC::UInt
    fun free_media_tracks = libvlc_media_tracks_release(tracks : MediaTrack**, count : LibC::UInt)
    fun get_media_type = libvlc_media_get_type(media : Media*) : MediaType
    fun get_media_state = libvlc_media_get_state(media : Media*) : State
    fun get_media_codec_description = libvlc_media_get_codec_description(track_type : TrackType, codec : LibC::UInt32T) : LibC::Char*
    fun get_media_statistics = libvlc_media_get_stats(media : Media*, stats : MediaStats*) : Bool # The Vlc_Media_Stats struct might be changed by the vlc lib (if true was returned)
    fun get_media_parsed_status = libvlc_media_get_parsed_status(media : Media*) : MediaParsedStatus
    fun get_media_subitems = libvlc_media_subitems(media : Media*) : MediaList*
    fun request_media_thumbnail_by_pos = libvlc_media_thumbnail_request_by_pos(media : Media*, pos : LibC::Float, speed : ThumbnailSeekSpeed, width : LibC::UInt, height : LibC::UInt, crop : Bool, picture_type : PictureType, timeout : Time) : MediaThumbnailRequest*
    fun request_media_thumbnail_by_time = libvlc_media_thumbnail_request_by_time(media : Media*, time : Time, speed : ThumbnailSeekSpeed, width : LibC::UInt, height : LibC::UInt, crop : Bool, picture_type : PictureType, timeout : Time) : MediaThumbnailRequest*
    fun cancel_media_thumbnail_request = libvlc_media_thumbnail_request_cancel(request : MediaThumbnailRequest*)
    fun destroy_media_thumbnail_request = libvlc_media_thumbnail_request_destroy(request : MediaThumbnailRequest*)

    fun set_media_user_data = libvlc_media_set_user_data(media : Media*, user_data : Void*)
    fun add_media_slave = libvlc_media_slaves_add(media : Media*, slave_type : SlaveType, priority : LibC::UInt, uri : LibC::Char*) : LibC::Int
    fun clear_media_slaves = libvlc_media_slaves_clear(media : Media*)
    fun get_media_slaves = libvlc_media_slaves_get(media : Media*, slaves : MediaSlave***) : LibC::UInt
    fun free_media_slaves = libvlc_media_slaves_release(slaves : MediaSlave**, count : LibC::UInt)

    fun get_media_meta = libvlc_media_get_meta(media : Media*, meta : Meta) : LibC::Char*
    fun set_media_meta = libvlc_media_set_meta(media : Media*, meta : Meta, value : LibC::Char*)
    fun save_media_meta = libvlc_media_save_meta(media : Media*) : Bool

    fun add_media_option = libvlc_media_add_option(media : Media*, option : LibC::Char*)
    fun add_media_option_flag = libvlc_media_add_option_flag(media : Media*, option : LibC::Char*, flags : LibC::Int)
    fun get_media_user_data = libvlc_media_get_user_data(media : Media*) : Void*
    fun stop_media_parse = libvlc_media_parse_stop(media : Media*)
    fun parse_media_with_options = libvlc_media_parse_with_options(media : Media*, options : MediaParseFlag, timeout : LibC::Int) : LibC::Int

    #MediaList
    fun new_media_list = libvlc_media_list_new(instance : Instance*) : MediaList*
    fun free_media_list = libvlc_media_list_release(media_list : MediaList*)
    fun retain_media_list = libvlc_media_list_retain(media_list : MediaList*)

    fun get_media_list_media = libvlc_media_list_media(media_list : MediaList*) : Media*
    fun set_media_list_media = libvlc_media_list_set_media(media_list : MediaList*, media : Media*)
    fun unlock_media_list = libvlc_media_list_unlock(media_list : MediaList*)
    fun lock_media_list = libvlc_media_list_lock(media_list : MediaList*)

    fun remove_media_list_media = libvlc_media_list_remove_index(media_list : MediaList*, pos : LibC::Int) : LibC::Int
    fun get_media_list_media = libvlc_media_list_item_at_index(media_list : MediaList*, pos : LibC::Int) : Media*
    fun is_media_list_readonly? = libvlc_media_list_is_readonly(media_list : MediaList*) : Bool
    fun index_of_media_list_media = libvlc_media_list_index_of_item(media_list : MediaList*, media : Media*) : LibC::Int
    fun insert_media_list_media = libvlc_media_list_insert_media(media_list : MediaList*, media : Media*, pos : LibC::Int) : LibC::Int
    fun add_media_list_media = libvlc_media_list_add_media(media_list : MediaList*, media : Media*) : LibC::Int
    fun get_media_list_count = libvlc_media_list_count(media_list : MediaList*) : LibC::Int

    # Media player
    fun new_media_player = libvlc_media_player_new(instance : Instance*) : MediaPlayer*
    fun new_media_player_from_media = libvlc_media_player_new_from_media(media : Media*) : MediaPlayer*
    fun free_media_player = libvlc_media_player_release(media_player : MediaPlayer*)
    fun retain_media_player = libvlc_media_player_retain(media_player : MediaPlayer*)

    fun set_audio_callbacks = libvlc_audio_set_callbacks(media_player : MediaPlayer*, play : AudioPlayCallback, pause : AudioPauseCallback, resume : AudioResumeCallback, flush : AudioFlushCallback, drain : AudioDrainCallback, opaque : Void*)
    fun set_audio_format_callbacks = libvlc_audio_set_format_callbacks(media_player : MediaPlayer*, setup : AudioSetupCallback, cleanup : AudioCleanupCallback)
    fun set_audio_volume_callback = libvlc_audio_set_volume_callback(media_player : MediaPlayer*, callback : AudioVolumeCallback)
    
    fun set_audio_channel = libvlc_audio_set_channel(media_player : MediaPlayer*, channel : LibC::Int) : LibC::Int
    fun set_audio_delay = libvlc_audio_set_delay(media_player : MediaPlayer*, delay : LibC::Int64T) : LibC::Int # delay in microseconds
    fun set_audio_mute = libvlc_audio_set_mute(media_player : MediaPlayer*, status : LibC::Int) # Not reliable!
    fun set_audio_track = libvlc_audio_set_track(media_player : MediaPlayer*, track : LibC::Int) : LibC::Int
    fun set_audio_volume = libvlc_audio_set_volume(media_player : MediaPlayer*, volume : LibC::Int) : LibC::Int#volume in percent --> between 0 and 100 (inclusive)
    fun set_audio_format = libvlc_audio_set_format(media_player : MediaPlayer*, format : LibC::Char*, rate : LibC::UInt, channels : LibC::UInt)

    fun set_media_player_media = libvlc_media_player_set_media(media_player : MediaPlayer*, media : Media*)
    fun get_media_player_media = libvlc_media_player_get_media(media_player : MediaPlayer*) : Media*
    
    fun can_media_player_pause? = libvlc_media_player_can_pause(media_player : MediaPlayer*) : Bool
    fun is_media_player_playing? = libvlc_media_player_is_playing(media_player : MediaPlayer*) : Bool
    fun is_media_player_seekable? = libvlc_media_player_is_seekable(media_player : MediaPlayer*) : Bool
    fun is_media_player_program_scrambled? = libvlc_media_player_program_scrambled(media_player : MediaPlayer*) : Bool
   
    fun get_media_player_length = libvlc_media_player_get_length(media_player : MediaPlayer*) : Time
    fun get_media_player_position = libvlc_media_player_get_position(media_player : MediaPlayer*) : LibC::Float
    fun get_media_player_state = libvlc_media_player_get_state(media_player : MediaPlayer*) : State
    fun get_media_player_time = libvlc_media_player_get_time(media_player : MediaPlayer*) : Time
    fun get_media_player_title = libvlc_media_player_get_title(media_player : MediaPlayer*) : LibC::Int
    fun get_media_player_title_count = libvlc_media_player_get_title_count(media_player : MediaPlayer*) : LibC::Int
    fun get_media_player_vout_count = libvlc_media_player_has_vout(media_player : MediaPlayer*) : LibC::Int

    fun add_media_player_slave = libvlc_media_player_add_slave(media_player : MediaPlayer*, slave_type : SlaveType, uri : LibC::Char*, select : Bool) : LibC::Int

    #MediaListPlayer
    fun new_media_list_player = libvlc_media_list_player_new(instance : Instance*) : MediaListPlayer*
    fun free_media_list_player = libvlc_media_list_player_release(mlp : MediaListPlayer*)
    fun retain_media_list_player = libvlc_media_list_player_retain(mlp : MediaListPlayer*)

    fun next_media_list_player = libvlc_media_list_player_next(mlp : MediaListPlayer*) : LibC::Int
    fun previous_media_player_list = libvlc_media_list_player_previous(mlp : MediaListPlayer*) : LibC::Int
    fun pause_media_list_player = libvlc_media_list_player_pause(mlp : MediaListPlayer*)
    fun play_media_list_player = libvlc_media_list_player_play(mlp : MediaListPlayer*)
    fun play_media_list_player_item = libvlc_media_list_player_play_item(mlp : MediaListPlayer*, media : Media*) : LibC::Int
    fun play_media_list_player_index = libvlc_media_list_player_play_index(mlp : MediaListPlayer*, index : LibC::Int) : LibC::Int
    fun set_media_list_player_pause = libvlc_media_list_player_set_pause(mlp : MediaListPlayer*, pause : LibC::Int)#0 : Play/Resume, Everything other: Pause
    fun set_media_list_player_media_list = libvlc_media_list_player_set_media_list(mlp : MediaListPlayer*, list : MediaList*)
    fun set_media_list_player_media_player = libvlc_media_list_player_set_media_player(mlp : MediaListPlayer*, player : MediaPlayer*)
    fun stop_media_list_player = libvlc_media_list_player_stop(media_list_player : MediaListPlayer*)
    fun set_media_list_player_playback_mode = libvlc_media_list_player_set_playback_mode(media_list_player : MediaListPlayer*, mode : PlaybackMode)


    fun get_media_list_player_media_player = libvlc_media_list_player_get_media_player(mlp : MediaListPlayer*) : MediaPlayer*
    fun get_media_list_player_state = libvlc_media_list_player_get_state(mlp : MediaListPlayer*) : State
    fun is_media_list_player_playing? = libvlc_media_list_player_is_playing(mlp : MediaListPlayer*) : Bool

    # Events
    fun get_media_event_manager = libvlc_media_event_manager(media : Media*) : EventManager*
    fun get_media_player_event_manager = libvlc_media_player_event_manager(media_player : MediaPlayer*) : EventManager*
    fun get_media_list_event_manager = libvlc_media_list_event_manager(media_list : MediaList*) : EventManager*
    fun get_media_list_player_event_manager = libvlc_media_list_player_event_manager(media_list_player : MediaListPlayer*) : EventManager*
    fun attach_event = libvlc_event_attach(event_manager : EventManager*, event_type : EventType, callback: Callback, user_data : Void*)
    fun detach_event = libvlc_event_detach(event_manager : EventManager*, event_type : EventType, callback: Callback, user_data : Void*)

    # Direct MediaPlayer control
    fun play_media_player = libvlc_media_player_play(player : MediaPlayer*)
    fun pause_media_player = libvlc_media_player_pause(player : MediaPlayer*)
    fun next_media_player_frame = libvlc_media_player_next_frame(media_player : MediaPlayer*)
    fun set_media_player_pause = libvlc_media_player_set_pause(media_player : MediaPlayer*, do_pause : LibC::Int) # Play / Resume == 0 , Pause != 0
    fun set_media_player_position = libvlc_media_player_set_position(media_player : MediaPlayer*, position : LibC::Float, fast_seeking : Bool) : LibC::Int
    fun set_media_player_rate = libvlc_media_player_set_rate(media_player : MediaPlayer*, rate : LibC::Float) : LibC::Int
    fun set_media_player_time = libvlc_media_player_set_time(media_player : MediaPlayer*, time : Time, fast_seeking : Bool) : LibC::Int
    fun stop_media_player = libvlc_media_player_stop(media_player : MediaPlayer*)


    fun set_media_player_xwindow = libvlc_media_player_set_xwindow(mp : MediaPlayer*, id : LibC::UInt32T)
    fun set_media_player_hwnd = libvlc_media_player_set_hwnd (mp : MediaPlayer*, hwnd : Void*)
    fun set_media_player_nsobject = libvlc_media_player_set_nsobject (mp : MediaPlayer*, nsobject : Void*)
    fun get_media_player_xwindow = libvlc_media_player_get_xwindow(mp : MediaPlayer*) : LibC::UInt32T
    fun get_media_player_hwnd = libvlc_media_player_get_hwnd (mp : MediaPlayer*) : Void*
    fun get_media_player_nsobject = libvlc_media_player_get_nsobject (mp : MediaPlayer*) : Void*

end

