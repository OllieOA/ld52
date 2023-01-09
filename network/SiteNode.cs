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
	public Node Pulser;
	public Vector2 PulseOffset;
	private Godot.Sprite _baseSprite;
	private Godot.Sprite _webSprite;
	private Godot.Object _colorTextUtils;
	private GDScript _colorTextUtilsPath;

	private static int offset_size = 15;

	public override void _Ready()
	{
		_site_label = GetNode<RichTextLabel>("address_label");
		_offset = Randy.Vector(-offset_size, offset_size);

		Pulser = GetNode<Node>("pulser");
		Pulser.Call("inject_ref", this);
		_colorTextUtilsPath = (GDScript)GD.Load("res://utils/color_text_utils.gd");
		_colorTextUtils = (Godot.Object)_colorTextUtilsPath.New();
		_baseSprite = GetNode<Sprite>("base_sprite");
		_webSprite = GetNode<Sprite>("web_sprite");
		_webSprite.Frame = Randy.Range(0, _webSprite.Hframes - 1);
	}

	public override void _Process(float delta)
	{
		Position = CalculatePosition();

		if (_data.IsActive)
			_baseSprite.Modulate = (Godot.Color)_colorTextUtils.Get("active_website_color");
		else if (_data.IsVisited)
			_baseSprite.Modulate = (Godot.Color)_colorTextUtils.Get("visited_website_color");
		else
			_baseSprite.Modulate = (Godot.Color)_colorTextUtils.Get("pending_website_color");
	}

	public Vector2 CalculatePosition()
	{
		float x = _data.LayerId * WidthGap * GapScale;
		float y = ((_data.Position * HeightGap) - (_data.SiblingCount * HeightGap / 2)) * GapScale;
		return new Vector2(x, y) + _offset + PulseOffset;
	}

	public void Assign(SiteData data)
	{
		_data = data;
		_data.NodeReference = this;
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