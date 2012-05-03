# HLSpider - the HTTP Live Streaming Spider
Asynchronously downloads .m3u8 playlists and reports back on whether or not the playlists are aligned in time.

## Purpose

Apple's HTTP Live Streaming (HLS) is used to deliver content with varying bit rate streams so a 3G connected cellphone can watch a video without buffering while a laptop can watch that same content in full 1080p. HLS uses .m3u8 playlist files (each bit rate having its own) which contain links to download the next video segment.It is very important that these different playlists are all at the same point in time so switching between bit rates is a seamless experience. 

Point HLSpider at multiple playlists and it will report back on whether or not these playlist contain the same number segment at the end of their playlist. 

## Usage

### Ruby

```
# Point the spider at multiple playlists
playlists = ["http://host.com/video1/playlist1.m3u8", "http://host.com/video1/playlist2.m3u8", "http://host.com/video1/playlist3.m3u8"]
spider = HLSpider.new(playlists)
```

OR

```
# The parent multi bit rate playlist
parent_url = "http://host.com/video1/all_bitrates_playlist.m3u8"
spider = HLSpider.new(parent_url)
```

```
spider.aligned?
spider.invalid_playlists

playlist = spider.playlists[0]
playlist.valid?
playlist.segments
playlist.url
playlist.file
playlist.target_duration
```

### Command line

```
hlspider --playlists=http://host.com/video1/playlist1.m3u8,http://host.com/video1/playlist2.m3u8,http://host.com/video1/playlist3.m3u8
```

OR 

```
hlspider --playlists=http://host.com/video1/all_bitrates_playlist.m3u8
```

#### Options
```
--loop TIMES    - How many times the spider should compare the playlists.
--sleep SECONDS - How many seconds the spider should sleep between loops.
```
