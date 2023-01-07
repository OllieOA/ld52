using Godot;
using System;

public class SiteNode : Node2D
{
    [Export] float WidthGap = 100;
    [Export] float HeightGap = 100;
    [Export] float GapScale = 1;

    private Vector2 _offset;
    private SiteData _data;
    public SiteData Data { get => _data; }

    public override void _Ready()
    {

    }

    public override void _Process(float delta)
    {
        Position = CalculatePosition();
        Update();
    }

    public Vector2 CalculatePosition()
    {
        float x = _data.LayerId * WidthGap * GapScale;
        float y = ((_data.Position * HeightGap) - (_data.SiblingCount * HeightGap / 2)) * GapScale;
        return new Vector2(x, y) + _offset;
    }

    public void Assign(SiteData data)
    {
        _data = data;
        GetNode<Label>("Label").Text = "" + Data.Id;
    }
}


// Signals
// Emitted
// Arrived(bool visited, string[] urls)

// // Listens to
// Goto(string url)
// Back()