package main

import (
	"log"
	"time"
	vlc "github.com/adrg/libvlc-go/v3"
)

func main() {
	err := vlc.Init("--no-video", "--quiet")
	if err != nil {
		log.Fatal(err)
	}
	defer vlc.Release()

	player, err := vlc.NewPlayer()
	if err != nil {
		log.Fatal(err)
	}
	defer func() {
		player.Stop()
		player.Release()
	}()

	media, err := player.LoadMediaFromURL("https://pd.npr.org/anon.npr-mp3/npr/news/newscast.mp3")
	if err != nil {
		log.Fatal(err)
	}
	defer media.Release()

	err = player.Play()
	if err != nil {
		log.Fatal(err)
	}

	time.Sleep(10 * time.Second)

	err = player.Stop()
	if err != nil {
		log.Fatal(err)
	}
}

