using Godot;
using System;

public class Mover : Node2D
{
    private SiteNetwork _network;
    private SiteNode _target;
    private bool _moving;

    public override void _Ready()
    {
        _network = GetParent<SiteNetwork>();
        _network.Connect("VisitSite", this, "OnVisitSite");
        _network.Connect("Arrival", this, "OnArrival");
    }

    public void OnVisitSite(int id)
    {
        _target = _network.SiteNodes[id];
        _moving = true;
    }

    public void OnArrival(int id)
    {
        _target = _network.SiteNodes[id];
        _moving = false;
    }


    int debug = 0;
    public override void _Process(float delta)
    {
        if (Input.IsActionJustPressed("debug_next"))
        {
            debug++;
            _network.EmitSignal("Goto", $"{debug}");
        }

        if (_moving)
        {
            Position = Position.LinearInterpolate(_target.Position, 0.1f);

            if (Position.DistanceTo(_target.Position) < 1)
            {
                _network.EmitSignal("Arrival", _target.Data.Id);
            }
        }
        else
        {
            if (_target == null)
                return;
            Position = _target.Position;
        }
    }
}
