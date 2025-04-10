https://github.com/Nodragem/twin-stick-shooter-starter-kit/assets/10520249/cb1b10fc-a31e-4a98-8d42-ad8bfacd0b1f

# Starter Kit for a Twin-Stick Shooter
Work-in-progress of a twin-stick shooter starter kit for Godot 4.
**NOTE:** Developed in and compatible with **Godot 4.3**. It looks like that `MeshLibrary` is breaking compatibility with 4.2. 

Credits and thank you to:
- @kaylousberg for the FREE [Kaykit Prototype Bits](https://kaylousberg.itch.io/prototype-bits) as a base for the 3D Assets;
- [Dialogic2](https://github.com/dialogic-godot/dialogic)'s contributors for their amazing dialogue manager, used for all my dialogues and cutscenes;
- [Beehave](https://github.com/bitbrain/beehave)'s contributors for their amazing decision tree add-on, used for my ennemies;
- @kenney for his [Input Prompt](https://kenney.nl/assets/input-prompts) assets and [Interface Sound](https://kenney.nl/assets/interface-sounds) assets;

Follow me on Twitter/X to get regular updates about the development and coming features: 

[![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/nodragem.svg?style=social&label=%20%40nodragem)](https://twitter.com/nodragem)

# Loading the project for the first time:

1) Clone or download this repository in a folder
2) Open the project in Godot (there will be a lot of errors, because of missing add-ons)
3) Click on AssetLib, search for Beehave and install it
4) Download [Dialogic2 from here](https://github.com/dialogic-godot/dialogic/archive/refs/tags/2.0-alpha-14.zip)
5) Unzip, find the `dialogic` folder (in the folder `addons`) and paste it in the `res://addons` folder of the Godot project
6) Go in `Project/Project Settings`, in the tab `Plugins`, activate both Beehave and Dialogic
7) (Optional) For your peace of mind, you might want to reload the project
8) Run the Game! 

# Features:
- Character Controller:
  - Logic based on a State Machine (inspired from GDQuest tutorials);
  - Animation System based on a Blend Tree
  - Fully modelled and rigged character
  - Support Gamepad or Keyboard (Keyboard + Mouse to be added at some point)
  - Camera follows Main Character and can be rotated with RT/LT
- Ennemy with Behaviour Tree based AI;
- Switch system: short switch, long switch, area switch can control enemy spawner and door through a switch hub
- Dialogue, Cutscene and Game Events: discover how to unfold a full story!
- Select between 3 controller schemes (One Stick Controller, Two Stick Controller, Two Stick Auto-Shoot Controller)
- Game Feel: Destructible elements, Hit feedback, Recoil animation (more to come)
- Collision layers are set up to reproduce the `infinite_inertia` property which was dropped in Godot 4
- Debug Layer

# Controls
Press `start` button of your gamepad to open a menu and select between 3 controller schemes:
- One Stick Controller (move with Left Stick, aim with Left Trigger, shoot with B)
- Two Stick Controller (move with Left Stick, aim with Right Stick, shoot with Left Trigger)
- Two Stick Auto-Shoot Controller (move with Left Stick, aim and shoot with Right Stick, Move Camera with RT/LT)

If no Gamepad only the One Stick Controller works at the moment:
- Move with `Arrow` keys
- Jump with `Space` key
- Aim with `Q` key
- Shoot with `W` key (you can only shoot if you are aiming)

Debug Layer which can be toggled with `L` key

# What is coming next?
- Game Feel: adding sounds
- Game Feel: add muzzle and hit VFX
- Add ennemies
