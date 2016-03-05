Song Sampler

This is an iPhone app that uses the Spotify API to search music. 

The view employs a searchbar, tableView with a custom cell of imageView and labels, and a programmatically defined toolbar. 
The music is played through AVQueuePlayer, and an AVAudioSession.
This app employs network calls and JSON parsing.

The toolbar buttons are used to determine playback:
    -the 'X' delete button, will clear the QueuePlayer song list.
    -the Play, Pause, and FastForward songs...do what one might expect.
    -the Refresh button is used to add all current songs on the tableView to the queue.

TableView:
By pressing the tableView entry, the selected song will  play before the queue continues with the next song.
The tableView additionaly has two slide actions, 
    -Play Next will add the selected song to the queue so that it will play once the current song finishes.  
    -Add will simply add the song to the end of the queue.

Search Bar:
Used to define the search:
    only searches when the user presses search, at which point the keyboard will disappear.
    if the user searches a number, rather than searching text, it will adjust the playback speed.  it uses a % 20 to determine the speed, and to avoid a divide by 0 error, normal speed is 0, slowest is 1, and fastest is 19 (+ 20k where k is an integer).
    searching 0 (or any multiple of 10) will also reset to normal playback 
    Pressing toolbar buttons will also reset the playback speed to normal.
