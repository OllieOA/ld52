using Godot;
using System;
using System.Collections.Generic;

public class SiteNetwork : Node2D
{
    [Export] public int MaxDepth = 10;
    [Export] public int MaxWidth = 4;

    private List<NetworkLayer> _layers;
    private RandomNumberGenerator _rng;

    public override void _Ready()
    {
        _layers = new List<NetworkLayer>();
        _rng = new RandomNumberGenerator();
        _rng.Randomize();

        for (int i = 0; i < MaxDepth; i++)
        {
            _layers.Add(CreateNetworkLayer());
        }
    }

    public NetworkLayer CreateNetworkLayer()
    {
        int count = _rng.RandiRange(1, MaxWidth);
        return new NetworkLayer().Generate(count);
    }


}

public class NetworkLayer
{
    public SiteData[] Sites;

    public NetworkLayer Generate(int count)
    {
        Sites = new SiteData[count];
        for (int i = 0; i < count; i++)
        {
            Sites[i] = new SiteData(this);
        }

        return this;
    }
}
