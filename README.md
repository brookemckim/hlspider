HLSpider
========
ASYNC .m3u8 downloader. Downloads .m3u8 playlist files and confirms their segments are properly aligned.

Usage
-----  
    hlspider

    Tasks:
      hlspider crawl --playlists=one two three  # Crawl the specified playlists and make sure their segments align
      hlspider help [TASK]                      # Describe available tasks or one specific task
    
<br />

    hlspider crawl --playlists=one two three

    Options:
    --playlists=one two three  
    [--sleep=N]  # Default: 5
    [--log=LOG]  # Disabled by default - Log provides some extra debug information
  

  
hlspider crawl --playlists=http://site.tld/playlist1.m3u8 http://site.tld/playlist2.m3u8 http://site.tld/playlist3.m3u8