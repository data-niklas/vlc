@[Link("vlc")]
lib LibVlc
    # Note to self: Programm might crash when getting the metadata and printing it as a string
    # --> Cause: the function returns a null Pointer: Pointer.null
    alias VlcInstance = Void*
    alias VlcMediaPlayer = Void*
    alias VlcMedia = Void*
    alias VlcTime = LibC::Int64T
    alias VlcEventManager = Void*
    alias VlcEventType = LibC::Int
    alias VlcCallback = Proc(VlcEventData*, Void*, Nil)
    alias VlcPicture = Void*
    alias VlcEqualizer = Void*

    enum VlcState
        NothingSpecial
        Opening
        Buffering
        Playing
        Paused
        Stopped
        Ended
        Error
    end

    enum VlcMediaType
        Unknown
        File
        Directory
        Disc
        Stream
        Playlist
    end

    enum VlcTrackType
        Unknown
        Audio
        Video
        Text
    end

    enum VlcMeta
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

    enum VlcMediaParsedStatus
        Skipped
        Failed
        Timeout
        Done
    end

    enum VlcEvent
        MediaMetaChanged = 0
        MediaSubItemAdded
        MediaDurationChanged
        MediaParsedChanged
        MediaFreed
        MediaStateChanged
        MediaSubItemTreeAdded
        MediaThumbnailGenerated

        MediaPlayerMediaChanged
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
        MediaListWillDeleteItem
        MediaListEndReached

        MediaListViewItemAdded = 0x300
        MediaListViewWillAddItem
        MediaListViewItemDeleted
        MediaListViewWillDeleteItem

        MediaListPlayerPlayed = 0x400
        MediaListPlayerNextItemSet
        MediaListPlayerStopped

        RendererDiscovererItemAdded = 0x502
        RendererDiscovererItemDeleted
    end

    enum VlcPictureType
        Argb
        Png
        Jpg
    end

    enum VlcRole
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


    struct VlcMediaStats
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

    struct VlcEventData
        type : VlcEvent
        p_obj : Void*
        new_state : VlcState    # Vars can be read, depending on the event type
        meta_type : VlcMeta
        new_child : VlcMedia*
        new_duration : LibC::Int64T
        md : VlcMedia*
        p_thumbnail : VlcPicture*
        item : VlcMedia*
        new_status : LibC::Int
        new_cache : LibC::Float
        new_chapter : LibC::Int
        new_position : LibC::Float
        new_time : VlcTime
        new_title : LibC::Int
        new_seekable : LibC::Int
        new_pausable : LibC::Int
        new_scrambled : LibC::Int
        new_count : LibC::Int
        index : LibC::Int
        psz_filename : Char*
        new_length : VlcTime
        new_media : VlcMedia*
        i_type : VlcTrackType
        i_id : LibC::Int
        volume : LibC::Float
        device : Char*
    end

    struct VlcAudioOutput
        psz_name : Char*
        psz_description : Char*
        p_next : VlcAudioOutput*
    end

    struct VlcTrackDescription
        i_id : LibC::Int
        psz_name : Char*
        p_next : VlcTrackDescription*
    end

    struct VlcOutputDevice
        psz_device : Char*
        psz_description : Char*
        p_next : VlcOutputDevice*
    end

    # Main and instance
    fun new_instance = libvlc_new(arguments_count: LibC::Int, arguments: LibC::Char*) : VlcInstance*
    fun free = libvlc_free(Void*)
    fun release_instance = libvlc_release(instance: VlcInstance*)
    fun version = libvlc_get_version(): LibC::Char*
    fun compiler_version = libvlc_get_compiler(): LibC::Char*
    
    fun get_audio_outputs = libvlc_audio_output_list_get(instance : VlcInstance*) : VlcAudioOutput*
    fun free_audio_outputs = libvlc_audio_output_list_release(outputs : VlcAudioOutput*) 
    fun set_audio_output = libvlc_audio_output_set(media_player : VlcMediaPlayer*, psz_name : Char*) : LibC::Int
    
    fun set_audio_channel = libvlc_audio_set_channel(media_player : VlcMediaPlayer*, channel : LibC::Int) : LibC::Int
    fun set_audio_delay = libvlc_audio_set_delay(media_player : VlcMediaPlayer*, delay : LibC::Int64T) : LibC::Int # delay in microseconds
    fun set_audio_mute = libvlc_audio_set_mute(media_player : VlcMediaPlayer*, status : LibC::Int) # Not reliable!
    fun set_audio_track = libvlc_audio_set_track(media_player : VlcMediaPlayer*, track : LibC::Int) : LibC::Int
    fun set_audio_volume = libvlc_audio_set_volume(media_player : VlcMediaPlayer*, volume : LibC::Int) : LibC::Int#volume in percent --> between 0 and 100 (inclusive)
    
    fun get_audio_channel = libvlc_audio_get_channel(media_player : VlcMediaPlayer*) : LibC::Int
    fun get_audio_delay = libvlc_audio_get_delay(media_player : VlcMediaPlayer*) : LibC::Int64T
    fun get_audio_mute = libvlc_audio_get_mute(media_player : VlcMediaPlayer*) : LibC::Int
    fun get_audio_track = libvlc_audio_get_track(media_player : VlcMediaPlayer*) : LibC::Int
    fun get_audio_track_count = libvlc_audio_get_track_count(media_player : VlcMediaPlayer*) : LibC::Int
    fun get_audio_volume = libvlc_audio_get_volume(media_player : VlcMediaPlayer*) : LibC::Int
    fun enum_audio_output_devices = libvlc_audio_output_device_enum(media_player : VlcMediaPlayer*) : VlcOutputDevice*
    fun get_audio_output_device = libvlc_audio_output_device_get(media_player : VlcMediaPlayer*) : Char*
    fun get_audio_output_devices = libvlc_audio_output_device_list_get(instance : VlcInstance*, audio_out : Char*) : VlcOutputDevice*
    fun free_audio_output_device = libvlc_audio_output_device_list_release(device : VlcOutputDevice*)
    fun set_audio_output_device = libvlc_audio_output_device_set(media_player : VlcMediaPlayer*, audio_output_module : Char*, device_id : Char*)

    fun get_audio_track_description = libvlc_audio_get_track_description(media_player : VlcMediaPlayer*) : VlcTrackDescription*

    fun toggle_audio_mute = libvlc_audio_toggle_mute(media_player : VlcMediaPlayer*)
    fun get_media_player_role = libvlc_media_player_get_role(media_player : VlcMediaPlayer*) : VlcRole
    fun set_media_player_role = libvlc_media_player_set_role(media_player : VlcMediaPlayer*, role : VlcRole) : LibC::Int
    fun set_media_player_equalizer = libvlc_media_player_set_equalizer(media_player : VlcMediaPlayer*, equalizer : VlcEqualizer*) : LibC::Int

    # Equalizer
    fun get_equalizer_amp_at_index = libvlc_audio_equalizer_get_amp_at_index(equalizer : VlcEqualizer*, band : LibC::Int) : LibC::Float
    fun get_equalizer_band_count = libvlc_audio_equalizer_get_band_count() : LibC::Int
    fun get_equalizer_band_frequency = libvlc_audio_equalizer_get_band_frequency(index : LibC::Int) : LibC::Float
    fun get_equalizer_preamp = libvlc_audio_equalizer_get_preamp(equalizer : VlcEqualizer*) : LibC::Float
    fun get_equalizer_preset_count = libvlc_audio_equalizer_get_preset_count() : LibC::Int
    fun get_equalizer_preset_name = libvlc_audio_equalizer_get_preset_name(index : LibC::Int) : Char*
    
    fun set_equalizer_amp_at_index = libvlc_audio_equalizer_set_amp_at_index(equalizer : VlcEqualizer*, amp : LibC::Float, band : LibC::Int) : LibC::Int # Float needs to be between -20 and 20 (inclusive)
    fun set_equalizer_preamp = libvlc_audio_equalizer_set_preamp(equalizer : VlcEqualizer*, preamp : LibC::Float) : LibC::Int
    fun new_equalizer = libvlc_audio_equalizer_new() : VlcEqualizer*
    fun new_equalizer_from_preset = libvlc_audio_equalizer_new_from_preset(index : LibC::Int) : VlcEqualizer*
    fun free_equalizer = libvlc_audio_equalizer_release(equalizer : VlcEqualizer*)

    # Media
    fun new_media_from_path = libvlc_media_new_path(instance : VlcInstance*, path : LibC::Char*) : VlcMedia*
    fun new_media_from_location = libvlc_media_new_location(instance : VlcInstance*, path : LibC::Char*) : VlcMedia*
    fun free_media = libvlc_media_release(media : VlcMedia*)
    fun get_media_resource_locator = libvlc_media_get_mrl(media : VlcMedia*) : LibC::Char*
    fun get_media_meta = libvlc_media_get_meta(media : VlcMedia*, meta : VlcMeta) : LibC::Char*
    fun get_media_duration = libvlc_media_get_duration(media : VlcMedia*) : VlcTime
    fun get_media_type = libvlc_media_get_type(media : VlcMedia*) : VlcMediaType
    fun get_media_state = libvlc_media_get_state(media : VlcMedia*) : VlcState
    fun get_media_statistics = libvlc_media_get_stats(media : VlcMedia*, stats : VlcMediaStats*) : Bool # The Vlc_Media_Stats struct might be changed by the vlc lib (if true was returned)
    fun get_media_parsed_status = libvlc_media_get_parsed_status(media : VlcMedia*) : VlcMediaParsedStatus

    # Media player
    fun new_media_player = libvlc_media_player_new(instance : VlcInstance*) : VlcMediaPlayer*
    fun new_media_player_from_media = libvlc_media_player_new_from_media(media : VlcMedia*) : VlcMediaPlayer*
    fun free_media_player = libvlc_media_player_release(media_player : VlcMediaPlayer*)
    fun set_media_player_media = libvlc_media_player_set_media(media_player : VlcMediaPlayer*, media : VlcMedia*)
    fun can_media_player_pause? = libvlc_media_player_can_pause(media_player : VlcMediaPlayer*) : Bool

    fun get_media_event_manager = libvlc_media_event_manager(media : VlcMedia*) : VlcEventManager*
    fun attach_event = libvlc_event_attach(event_manager : VlcEventManager*, event_type : VlcEventType, callback: VlcCallback, user_data : Void*)

    fun play = libvlc_media_player_play(player : VlcMediaPlayer*)
    fun pause = libvlc_media_player_pause(player : VlcMediaPlayer*)

end

