using Godot;
using System;

public class SiteData : Resource
{
    private NetworkLayer _layer;
    public SiteData(NetworkLayer layer)
    {
        _layer = layer;
    }
}
