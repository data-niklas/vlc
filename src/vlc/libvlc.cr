@[Link("vlc")]
lib LibVlc
    # Note to self: Programm might crash when getting the metadata and printing it as a string
    # --> Cause: the function returns a null Pointer: Pointer.null
    alias VlcInstance = Void*
    alias VlcMediaPlayer = Void*
    alias VlcMedia = Void*
    alias VlcTime = LibC::Int64T

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

    # Main and instance
    fun new_instance = libvlc_new(arguments_count: LibC::Int, arguments: LibC::Char*) : VlcInstance*
    fun free = libvlc_free(Void*) : Void
    fun release_instance = libvlc_release(instance: VlcInstance*) : Void
    fun version = libvlc_get_version(): LibC::Char*
    fun compiler_version = libvlc_get_compiler(): LibC::Char*

    # Media
    fun new_media_from_path = libvlc_media_new_path(instance : VlcInstance*, path : LibC::Char*) : VlcMedia*
    fun new_media_from_location = libvlc_media_new_location(instance : VlcInstance*, path : LibC::Char*) : VlcMedia*
    fun release_media = libvlc_media_release(media : VlcMedia*) : Void
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
    fun release_media_player = libvlc_media_player_release(media_player : VlcMediaPlayer*) : Void
    fun set_media_player_media = libvlc_media_player_set_media(media_player : VlcMediaPlayer*, media : VlcMedia*)

    fun play = libvlc_media_player_play(player : VlcMediaPlayer*) : Void

end

