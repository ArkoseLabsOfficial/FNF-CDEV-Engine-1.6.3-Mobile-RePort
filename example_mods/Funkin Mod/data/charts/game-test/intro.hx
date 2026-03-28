function init() {
    runOnFreeplay = true;
}
var video:FlxVideo;
function introStart() {
    video = new FlxVideo();
    if (isIOS()) {
        video.load(Paths.video("game_cutscene"));
        video.play();
        FlxG.addChildBelowMouse(video);
    } else {
        video.play(Paths.video("game_cutscene"));
    }
    video.onEndReached.add(function()
    {
        video.dispose();
        video = null;
        startSong();
        return;
    }, true);
    public["cutscene_video"] = video;
}

function update(e) {
    if (FlxG.keys.justPressed.SPACE){
        //startSong();
        video.stop();
        video.dispose();
        video = null;
        startSong();
    }
}