using Godot;
using System;

public class ding : Button
{

    public override void _Ready()
    {
        Connect("pressed", this, "OnClick");
    }

    public void OnClick()
    {
        GD.Print("Dong");
        Text += "!";
    }
}
