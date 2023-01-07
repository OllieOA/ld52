using Godot;
using System;
using System.Collections.Generic;

public class SiteData : Resource
{
    private static int instanceCount = 0;
    private NetworkLayer _layer;
    private int _position;
    private int _id;

    public List<SiteData> Neighbours;
    public int Id { get => _id; }
    public int Position { get => _position; }
    public int LayerId { get => _layer.Id; }
    public int SiblingCount { get => _layer.Size - 1; }
    public bool HasConnection { get => Neighbours.Count > 0; }


    public SiteData(NetworkLayer layer, int position)
    {
        _id = instanceCount++;
        _layer = layer;
        _position = position;
        Neighbours = new List<SiteData>();
    }

    public void ConnectTo(SiteData other)
    {
        if (!Neighbours.Contains(other))
            Neighbours.Add(other);
    }

    public bool IsAdjacentTo(SiteData other)
    {
        return Position + 1 == other.Position || Position - 1 == other.Position;
    }

    public static void Connect(SiteData from, SiteData to)
    {
        GD.Print($"Connecting {from.Id} to {to.Id}");
        from.ConnectTo(to);
        to.ConnectTo(from);
    }


}
