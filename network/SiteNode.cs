using Godot;
using System;

public class SiteNode : Node2D
{
    [Export] float WidthGap = 100;
    [Export] float HeightGap = 100;
    [Export] float GapScale = 1;
    [Signal] public delegate void LabelAssigned();

    private Vector2 _offset;
    private SiteData _data;
    private RichTextLabel _site_label;
    public SiteData Data { get => _data; }
    public RichTextLabel SiteLabel { get => _site_label; }

    public override void _Ready()
    {
        _site_label = GetNode<RichTextLabel>("address_label");
    }

    public override void _Process(float delta)
    {
        Position = CalculatePosition();

        if (_data.IsActive)
            Modulate = Colors.Cyan;
        else
            Modulate = Colors.White;
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
        _site_label.ParseBbcode("[center]" + Data.Address + "[/center]");
        EmitSignal("LabelAssigned");
    }

    public void ShowLabel()
    {
        _site_label.Show();
    }

    public void HideLabel()
    {
        _site_label.Hide();
    }
}