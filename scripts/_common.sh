#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
#REMOVEME? pkg_dependencies="cargo rustc ca-certificates librust-backtrace+libbacktrace-dev build-essential git git-lfs"

#=================================================
# PERSONAL HELPERS
#=================================================

function setup_source {
	ynh_setup_source --dest_dir="$install_dir"

	patch_source

	set_permissions
}

function patch_source {
	if [ ! -z "$world_map_size_lg_x" ] || [ ! -z "$world_map_size_lg_y" ]; then
		if [ -z "$world_map_size_lg_x" ]; then
			world_map_size_lg_x="10"
		fi
		if [ -z "$world_map_size_lg_y" ]; then
			world_map_size_lg_y="10"
		fi
		ynh_replace_string -m "MapSizeLg::new(Vec2 { x: [0-9]\{1,\}, y: [0-9]\{1,\} }" -r "MapSizeLg::new(Vec2 { x: $world_map_size_lg_x, y: $world_map_size_lg_y }" -f "$install_dir/world/src/sim/mod.rs"
	fi

	if [ ! -z "$continent_scale_hack" ]; then
		ynh_replace_string -m "continent_scale_hack = [0-9]\{1,\}\.[0-9]\{1,\}" -r "continent_scale_hack = $continent_scale_hack" -f "$install_dir/world/src/sim/mod.rs"
	fi

	if [ ! -z "$days_in_month" ]; then
		ynh_replace_string -m "MONTH: f32 = [0-9]\{1,\}\.[0-9]\{1,\}" -r "MONTH: f32 = $days_in_month"  -f "$install_dir/world/src/sim2/mod.rs"
	fi

	if [ ! -z "$months_in_year" ]; then
		ynh_replace_string -m "YEAR: f32 = [0-9]\{1,\}\.[0-9]\{1,\}" -r "YEAR: f32 = $months_in_year"  -f "$install_dir/world/src/sim2/mod.rs"
	fi

	if [ ! -z "$months_in_tick" ]; then
		ynh_replace_string -m "TICK_PERIOD: f32 = [0-9]\{1,\}\.[0-9]\{1,\}" -r "TICK_PERIOD: f32 = $months_in_tick"  -f "$install_dir/world/src/sim2/mod.rs"
	fi
	
	if [ ! -z "$years_in_history" ]; then
		ynh_replace_string -m "HISTORY_DAYS: f32 = [0-9]\{1,\}\.[0-9]\{1,\}" -r "HISTORY_DAYS: f32 = $years_in_history"  -f "$install_dir/world/src/sim2/mod.rs"
	fi

	if [ $generate_economy_csv -eq 1 ]; then
		ynh_replace_special_string -m "GENERATE_CSV: bool = false" -r "GENERATE_CSV: bool = true" -f "$install_dir/world/src/sim2/mod.rs"
	fi

	if [ $allow_inter_site_trade -eq 0 ]; then
		ynh_replace_special_string -m "INTER_SITE_TRADE: bool = true" -r "INTER_SITE_TRADE: bool = false" -f "$install_dir/world/src/sim2/mod.rs"
	fi

}

function set_permissions {
	mkdir -p "$install_dir"
	chown -R root:$app "$install_dir"
	chmod -R g=u,g-w,o-rwx "$install_dir"

	mkdir -p "$data_path"
	chown -R $app:$app "$data_path"
	chmod -R g=u,g-w,o-rwx "$data_path"

	mkdir -p "/var/log/$app"
	chmod -R o-rwx "/var/log/$app"
}

function install_rust {
	sudo -u $app bash -c '
		curl https://sh.rustup.rs -sSf | sh -s -- -q -y 2>&1
		source ~/.cargo/env
		rustup toolchain install $(cat "'"$install_dir/rust-toolchain"'") 2>&1
	'
}

function compile_server {
	install_rust

	chown -R $app:$app "$install_dir"
	pushd "$install_dir"
		sudo -u $app bash -c "
			source ~/.cargo/env
			NIX_GIT_HASH=\"cf2bdb20/2021-06-12-08:55\" NIX_GIT_TAG=\"v0.10.0\" VELOREN_ASSETS=\"$install_dir/assets\"  RUSTFLAGS=\"-D warnings\" VELOREN_USERDATA_STRATEGY=system cargo build --bin veloren-server-cli --release --quiet 2>&1
		"
	popd

	sudo -u $app ln -sf "$install_dir/assets" "$data_path/assets"

	set_permissions
}

function generate_custom_world {
	map_generated=0

	add_configuration_files

	pushd "$data_path"
		grep -q "Server is ready to accept connections." <((sudo -u $app VELOREN_ASSETS="$install_dir/assets" $install_dir/target/release/veloren-server-cli --basic & echo $! >&3 ) 3>pid)
		kill "$(<pid)"
		fuser $port/tcp -k
	popd

	map_generated=1
}

function add_configuration_files {
	mkdir -p "$data_path/.local/share/veloren/userdata/server/server_config"
	mkdir -p "$data_path/maps"

	if [ $generate_custom_world -eq 1 ]; then
		if [ $map_generated -eq 1 ] ; then
			map_file_string="Some(Load(\"maps/$(ls -1qt $data_path/maps | head -n 1)\"))"
		else
			map_file_string="Some(Save)"
		fi
	else
		map_file_string="None"
	fi

	if [ "$auth_server_address" == "None" ]; then
		auth_server_address_string="None"	
	else
		auth_server_address_string="Some(\"$auth_server_address\")"
	fi

	if [ "$max_view_distance" -eq 0 ]; then
		max_view_distance_string="None"
	else
		max_view_distance_string="Some($max_view_distance)"
	fi
	
	ynh_add_config --template="settings.ron" --destination="$data_path/.local/share/veloren/userdata/server/server_config/settings.ron"
	ynh_add_config --template="description.ron" --destination="$data_path/.local/share/veloren/userdata/server/server_config/description.ron"

	set_permissions
}

function get_app_settings {
#REMOVEME? #REMOVEME? 	install_dir=$(ynh_app_setting_get --app=$app --key=install_dir)
#REMOVEME? 	data_path=$(ynh_app_setting_get --app=$app --key=data_path)
#REMOVEME? 	port=$(ynh_app_setting_get --app=$app --key=port)
#REMOVEME? 	metrics_port=$(ynh_app_setting_get --app=$app --key=metrics_port)
#REMOVEME? 	server_name=$(ynh_app_setting_get --app=$app --key=server_name)
#REMOVEME? 	description=$(ynh_app_setting_get --app=$app --key=description)
#REMOVEME? 	auth_server_address=$(ynh_app_setting_get --app=$app --key=auth_server_address)
#REMOVEME? 	max_players=$(ynh_app_setting_get --app=$app --key=max_players)
#REMOVEME? 	max_view_distance=$(ynh_app_setting_get --app=$app --key=max_view_distance)
#REMOVEME? 	max_player_group_size=$(ynh_app_setting_get --app=$app --key=max_player_group_size)
#REMOVEME? 	generate_custom_world=$(ynh_app_setting_get --app=$app --key=generate_custom_world)
#REMOVEME? 	world_seed=$(ynh_app_setting_get --app=$app --key=world_seed)
#REMOVEME? 	world_map_size_lg_x=$(ynh_app_setting_get --app=$app --key=world_map_size_lg_x)
#REMOVEME? 	world_map_size_lg_y=$(ynh_app_setting_get --app=$app --key=world_map_size_lg_y)
#REMOVEME? 	continent_scale_hack=$(ynh_app_setting_get --app=$app --key=continent_scale_hack)
#REMOVEME? 	days_in_month=$(ynh_app_setting_get --app=$app --key=days_in_month)
#REMOVEME? 	months_in_year=$(ynh_app_setting_get --app=$app --key=months_in_year)
#REMOVEME? 	months_in_tick=$(ynh_app_setting_get --app=$app --key=months_in_tick)
#REMOVEME? 	years_in_history=$(ynh_app_setting_get --app=$app --key=years_in_history)
#REMOVEME? 	generate_economy_csv=$(ynh_app_setting_get --app=$app --key=generate_economy_csv)
#REMOVEME? 	allow_inter_site_trade=$(ynh_app_setting_get --app=$app --key=allow_inter_site_trade)
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
