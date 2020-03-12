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

    # Main and instance
    fun new_instance = libvlc_new(arguments_count: LibC::Int, arguments: LibC::Char*) : VlcInstance*
    fun free = libvlc_free(Void*)
    fun release_instance = libvlc_release(instance: VlcInstance*)
    fun version = libvlc_get_version(): LibC::Char*
    fun compiler_version = libvlc_get_compiler(): LibC::Char*

    # Media
    fun new_media_from_path = libvlc_media_new_path(instance : VlcInstance*, path : LibC::Char*) : VlcMedia*
    fun new_media_from_location = libvlc_media_new_location(instance : VlcInstance*, path : LibC::Char*) : VlcMedia*
    fun release_media = libvlc_media_release(media : VlcMedia*)
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
    fun release_media_player = libvlc_media_player_release(media_player : VlcMediaPlayer*)
    fun set_media_player_media = libvlc_media_player_set_media(media_player : VlcMediaPlayer*, media : VlcMedia*)
    fun can_media_player_pause? = libvlc_media_player_can_pause(media_player : VlcMediaPlayer*) : Bool

    fun get_media_event_manager = libvlc_media_event_manager(media : VlcMedia*) : VlcEventManager*
    fun attach_event = libvlc_event_attach(event_manager : VlcEventManager*, event_type : VlcEventType, callback: VlcCallback, user_data : Void*)

    fun play = libvlc_media_player_play(player : VlcMediaPlayer*)
    fun pause = libvlc_media_player_pause(player : VlcMediaPlayer*)

end

