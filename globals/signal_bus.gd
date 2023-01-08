extends Node

signal website_completed(website_id, data_scraped)
signal unique_match_found(website_str)
signal website_str_confirmed(website_str)
signal no_str_matched(website_str)