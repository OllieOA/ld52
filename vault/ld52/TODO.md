### Visual
- [x] Positive and negative typing shake
- [x] Add background
- [x] Add firewall as shader
- [x] Add offset to network
- [x] Add wobble/pulse to network
- [x] Make better node sprite
	- [ ] Make node sprite instead be a control node that can be zoomed in
- [x] Make better mover sprite
- [x] Add colours to completed segments of lines
- [ ] Add more website sprites

### Gameplay
- [ ] Main menu
- [ ] Score retention
- [x] Add firewall proximity meter
- [ ] Add game over sequence

### Audio
- [x] Positive and negative typing sounds
- [ ] Music

### Stretch
- [ ] ~~Add fake website popup behind minigame (for feeling)~~
- [ ] Add corruption to text (obfuscating characters some of the time with a special character)

### FIX
- [ ] Network generator
E 0:00:01.972   void NetworkLayer.CalculateDisconnectedPaths(): System.Exception: Couldn't connect bad nodes
  <C++ Error>   Unhandled exception
  <C++ Source>  P:/Godot_Projects/ld52/network/SiteNetwork.cs:224 @ void NetworkLayer.CalculateDisconnectedPaths()()
  <Stack Trace> SiteNetwork.cs:224 @ void NetworkLayer.CalculateDisconnectedPaths()()
                SiteNetwork.cs:48 @ void SiteNetwork.Generate()()
                SiteNetwork.cs:28 @ void SiteNetwork._Ready()()
