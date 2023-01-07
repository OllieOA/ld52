using Godot;
using System;
using System.Collections.Generic;

public class SiteData : Resource
{
    private static int instanceCount = 0;
    private NetworkLayer _layer;
    private int _position;
    private int _id;
    private bool _active;
    private bool _visited;
    private string _address;

    public List<SiteData> Neighbours;
    public int Id { get => _id; }
    public int Position { get => _position; }
    public int LayerId { get => _layer.Id; }
    public int SiblingCount { get => _layer.Size - 1; }
    public bool HasConnection { get => Neighbours.Count > 0; }
    public bool IsActive { get => _active; }
    public bool IsVisited { get => _visited; }
    public string Address { get => _address; }

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


    public void Activate()
    {
        GD.Print($"{Id} is activated");
        _active = true;
        _visited = true;
    }

    public void Deactivate()
    {
        _active = false;
    }

    public string[] AvailableAddresses()
    {
        string[] addresses = new string[Neighbours.Count];
        for (int i = 0; i < Neighbours.Count; i++)
        {
            addresses[i] = Neighbours[i]._address;
        }
        return addresses;
    }

    public SiteData FindFromAddress(string address)
    {
        foreach (SiteData data in Neighbours)
        {
            if (data._address == address)
                return data;
        }
        return null;
    }
}
