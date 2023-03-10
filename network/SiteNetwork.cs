using Godot;
using System;
using System.Collections.Generic;

public class SiteNetwork : Node2D
{
	[Export] public int MaxDepth = 100;
	[Export] public int MaxWidth = 5;
	[Export] public int MinWidth = 3;
	[Export] public PackedScene SiteNodeScene;
	[Signal] public delegate void Arrived(bool visited, string[] addresses);
	[Signal] public delegate void Goto(string address);
	[Signal] public delegate void VisitSite(int id);
	[Signal] public delegate void Arrival(int id);

	public List<NetworkLayer> Layers;
	public Dictionary<int, SiteNode> SiteNodes;
	public SiteData CurrentSite;
	private Godot.Object _colorTextUtils;
	private GDScript _colorTextUtilsPath;

	public override void _Ready()
	{
		Layers = new List<NetworkLayer>();
		SiteNodes = new Dictionary<int, SiteNode>();

		Connect("Goto", this, "OnGoto");
		Connect("Arrival", this, "OnArrival");
		this.GetParent().Connect("WebsitePromptFinished", this, "ShowAdjacentNodes");

		Generate();

		_colorTextUtilsPath = (GDScript)GD.Load("res://utils/color_text_utils.gd");
		_colorTextUtils = (Godot.Object)_colorTextUtilsPath.New();
	}

	public void Generate()
	{
		for (int i = 0; i < MaxDepth; i++)
		{
			int count = Randy.Range(MinWidth, MaxWidth);
			if (i == 0)
				count = 1;
			Layers.Add(new NetworkLayer(i, this).Generate(count));
		}

		for (int i = 1; i < Layers.Count; i++)
		{
			Layers[i].CalculateRandomPath();
		}

		for (int i = 1; i < Layers.Count; i++)
		{
			Layers[i].CalculateDisconnectedPaths();
		}

		InstantiateNetwork();

		EmitSignal("Arrival", (Layers[0].Sites[0].Id));
	}

	public void Regenerate()
	{
		foreach (SiteNode node in SiteNodes.Values)
		{
			node.QueueFree();
		}

		Layers = new List<NetworkLayer>();
		SiteNodes = new Dictionary<int, SiteNode>();

		Generate();
		Update();
	}

	public void InstantiateNetwork()
	{
		foreach (NetworkLayer layer in Layers)
		{
			foreach (SiteData siteData in layer.Sites)
			{
				SiteNode node = SiteNodeScene.Instance<SiteNode>();
				AddChild(node);
				node.Assign(siteData);
				SiteNodes.Add(siteData.Id, node);
			}
		}
	}

	public void OnGoto(string address)
	{
		SiteData site = CurrentSite.FindFromAddress(address);

		if (site != null)
		{
			EmitSignal("VisitSite", site.Id);
			CurrentSite.Deactivate();

			// Then hide all other nodes that aren't being pinged
			foreach (SiteNode adj_site in GetAdjacentNodes())
			{
				if (adj_site.Data.Id != site.Id)
				{
					adj_site.HideLabel();
				}
			}
		}

	}

	public void OnArrival(int id)
	{
		CurrentSite = SiteNodes[id].Data;
		if (CurrentSite.IsVisited)
		{
			ShowAdjacentNodes();  // This is otherwise skipped if there is no minigame
		}
		bool visited = CurrentSite.IsVisited;
		CurrentSite.Activate();
		EmitSignal("Arrived", visited, CurrentSite.AvailableAddresses());

	}

	public void ShowAdjacentNodes()
	{
		foreach (SiteNode site in GetAdjacentNodes())
		{
			site.ShowLabel();
		}
	}

	public SiteNode[] GetAdjacentNodes()
	{
		string[] available_addresses = CurrentSite.AvailableAddresses();
		SiteNode[] adjacent_nodes = new SiteNode[available_addresses.Length];
		for (int i = 0; i < available_addresses.Length; i++)
		{
			SiteData site = CurrentSite.FindFromAddress(available_addresses[i]);
			SiteNode siteNode = SiteNodes[site.Id];
			adjacent_nodes[i] = siteNode;
		}
		return adjacent_nodes;
	}

	public override void _Process(float delta)
	{
		Update();
	}

	public override void _Draw()
	{
		foreach (SiteNode site in SiteNodes.Values)
		{
			foreach (SiteData otherData in site.Data.Neighbours)
			{
				if (site.Data.LayerId <= otherData.LayerId)
				{
					Vector2 from = site.CalculatePosition();
					Vector2 to = SiteNodes[otherData.Id].CalculatePosition();

					Color lineColor;

					if (site.Data.IsVisited & otherData.IsVisited)
					{
						lineColor = (Godot.Color)_colorTextUtils.Get("visited_link_color");
					}
					else
					{
						lineColor = (Godot.Color)_colorTextUtils.Get("unvisited_link_color");
					}

					DrawLine(from, to, lineColor, 3);
				}
			}
		}
	}
}

public class NetworkLayer
{
	public SiteData[] Sites;
	private int _layerId;
	private SiteNetwork _network;
	public int Id { get => _layerId; }
	public int Size { get => Sites.Length; }

	public NetworkLayer(int id, SiteNetwork network)
	{
		_layerId = id;
		_network = network;
	}

	public NetworkLayer Generate(int count)
	{
		Sites = new SiteData[count];
		GenerateSites();
		if (Id > 0)
		{
			CalculateMainPath();
		}

		return this;
	}

	public void GenerateSites()
	{
		for (int i = 0; i < Size; i++)
		{
			Sites[i] = new SiteData(this, i);
		}
	}

	public void CalculateMainPath()
	{
		SiteData prevSite = GetPrevious().FindConnected();
		if (prevSite == null)
		{
			CalculateRandomPath();
			return;
		}
		SiteData.Connect(GetRandomChild(), prevSite);
	}

	public void CalculateRandomPath()
	{
		SiteData.Connect(GetRandomChild(), GetPrevious().GetRandomChild());
	}

	public void CalculateDisconnectedPaths()
	{
		int retryCount = 0;
		while (FindDisconnected() != null && retryCount++ < 1000)
		{
			SiteData disconnectedSite = FindDisconnected();
			SiteData randomSite = GetRandomChild();
			if (randomSite != disconnectedSite && randomSite.IsAdjacentTo(disconnectedSite))
				SiteData.Connect(randomSite, disconnectedSite);
		}

		if (retryCount >= 30)
			throw new Exception("Couldn't connect bad nodes");
	}

	public void CalculateHorizontalPath()
	{
		for (int i = 1; i < Size; i++)
		{
			SiteData.Connect(Sites[i], Sites[i - 1]);
		}
	}

	public SiteData GetRandomChild()
	{
		return Randy.FromArray<SiteData>(Sites);
	}

	public SiteData FindConnected()
	{
		foreach (SiteData site in Sites)
		{
			if (site.HasConnection)
				return site;
		}
		return null;
	}

	public SiteData FindDisconnected()
	{
		foreach (SiteData site in Sites)
		{
			if (!site.HasConnection)
				return site;
		}
		return null;
	}

	public NetworkLayer GetPrevious()
	{
		if (_layerId == 0)
			return null;

		return _network.Layers[_layerId - 1];
	}
}
