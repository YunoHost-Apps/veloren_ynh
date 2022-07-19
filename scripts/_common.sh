#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies="ca-certificates librust-backtrace+libbacktrace-dev build-essential git git-lfs"

#=================================================
# PERSONAL HELPERS
#=================================================

function setup_source {
	ynh_setup_source --dest_dir="$final_path/build"

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
		ynh_replace_string -m "MapSizeLg::new(Vec2 { x: [0-9]\{1,\}, y: [0-9]\{1,\} }" -r "MapSizeLg::new(Vec2 { x: $world_map_size_lg_x, y: $world_map_size_lg_y }" -f "$final_path/build/world/src/sim/mod.rs"
	fi

	if [ ! -z "$continent_scale_hack" ]; then
		ynh_replace_string -m "continent_scale_hack = [0-9]\{1,\}\.[0-9]\{1,\}" -r "continent_scale_hack = $continent_scale_hack" -f "$final_path/build/world/src/sim/mod.rs"
	fi

	if [ ! -z "$days_in_month" ]; then
		ynh_replace_string -m "MONTH: f32 = [0-9]\{1,\}\.[0-9]\{1,\}" -r "MONTH: f32 = $days_in_month"  -f "$final_path/build/world/src/sim2/mod.rs"
	fi

	if [ ! -z "$months_in_year" ]; then
		ynh_replace_string -m "YEAR: f32 = [0-9]\{1,\}\.[0-9]\{1,\}" -r "YEAR: f32 = $months_in_year"  -f "$final_path/build/world/src/sim2/mod.rs"
	fi

	if [ ! -z "$months_in_tick" ]; then
		ynh_replace_string -m "TICK_PERIOD: f32 = [0-9]\{1,\}\.[0-9]\{1,\}" -r "TICK_PERIOD: f32 = $months_in_tick"  -f "$final_path/build/world/src/sim2/mod.rs"
	fi
	
	if [ ! -z "$years_in_history" ]; then
		ynh_replace_string -m "HISTORY_DAYS: f32 = [0-9]\{1,\}\.[0-9]\{1,\}" -r "HISTORY_DAYS: f32 = $years_in_history"  -f "$final_path/build/world/src/sim2/mod.rs"
	fi

	if [ $generate_economy_csv -eq 1 ]; then
		ynh_replace_special_string -m "GENERATE_CSV: bool = false" -r "GENERATE_CSV: bool = true" -f "$final_path/build/world/src/sim2/mod.rs"
	fi

	if [ $allow_inter_site_trade -eq 0 ]; then
		ynh_replace_special_string -m "INTER_SITE_TRADE: bool = true" -r "INTER_SITE_TRADE: bool = false" -f "$final_path/build/world/src/sim2/mod.rs"
	fi

}

function set_permissions {
	mkdir -p "$final_path"
	chown -R $app:$app "$final_path"
	chmod -R g=u,g-w,o-rwx "$final_path"

	mkdir -p "$data_path"
	chown -R $app:$app "$data_path"
	chmod -R g=u,g-w,o-rwx "$data_path"

	mkdir -p "/var/log/$app"
	chmod -R o-rwx "/var/log/$app"
}

function install_rust {
	ynh_exec_warn_less ynh_exec_as "$app" RUSTUP_HOME="$final_path"/.rustup CARGO_HOME="$final_path"/.cargo bash -c 'curl -sSf -L https://static.rust-lang.org/rustup.sh | sh -s -- -y --default-toolchain stable'
}

function compile_server {
	install_rust

	chown -R $app:$app "$final_path"
	export PATH="$PATH:$final_path/.cargo/bin:$final_path/.local/bin:/usr/local/sbin" 
	pushd "$final_path/build"
		ynh_exec_warn_less ynh_exec_as "$app" env PATH="$PATH" NIX_GIT_HASH="cf2bdb20/2021-06-12-08:55" NIX_GIT_TAG="v0.10.0" VELOREN_ASSETS="$final_path/assets"  RUSTFLAGS="-D warnings" VELOREN_USERDATA_STRATEGY=system cargo build --bin veloren-server-cli --release
	popd

	ynh_secure_remove --file="$final_path/live"
	mkdir -p "$final_path/live/assets/"
	cp -af "$final_path/build/target/release/veloren-server-cli" "$final_path/live/veloren-server-cli"
	cp -af "$final_path/build/assets/common" "$final_path/live/assets/common"
	cp -af "$final_path/build/assets/server" "$final_path/live/assets/server"
	cp -af "$final_path/build/assets/world" "$final_path/live/assets/world"

	# Remove build files and rustup
	ynh_secure_remove --file="$final_path/build"
	ynh_secure_remove --file="$final_path/.cargo"
	ynh_secure_remove --file="$final_path/.rustup"

	ynh_exec_as $app ln -sf "$final_path/live/assets" "$data_path/assets"

	set_permissions
}

function generate_custom_world {
	map_generated=0

	add_configuration_files

	pushd "$data_path"
		grep -q "Server is ready to accept connections." <((ynh_exec_as $app VELOREN_ASSETS="$final_path/assets" $final_path/live/veloren-server-cli & echo $! >&3 ) 3>pid)
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
	final_path=$(ynh_app_setting_get --app=$app --key=final_path)
	data_path=$(ynh_app_setting_get --app=$app --key=data_path)
	port=$(ynh_app_setting_get --app=$app --key=port)
	metrics_port=$(ynh_app_setting_get --app=$app --key=metrics_port)
	server_name=$(ynh_app_setting_get --app=$app --key=server_name)
	description=$(ynh_app_setting_get --app=$app --key=description)
	auth_server_address=$(ynh_app_setting_get --app=$app --key=auth_server_address)
	max_players=$(ynh_app_setting_get --app=$app --key=max_players)
	max_view_distance=$(ynh_app_setting_get --app=$app --key=max_view_distance)
	max_player_group_size=$(ynh_app_setting_get --app=$app --key=max_player_group_size)
	generate_custom_world=$(ynh_app_setting_get --app=$app --key=generate_custom_world)
	world_seed=$(ynh_app_setting_get --app=$app --key=world_seed)
	world_map_size_lg_x=$(ynh_app_setting_get --app=$app --key=world_map_size_lg_x)
	world_map_size_lg_y=$(ynh_app_setting_get --app=$app --key=world_map_size_lg_y)
	continent_scale_hack=$(ynh_app_setting_get --app=$app --key=continent_scale_hack)
	days_in_month=$(ynh_app_setting_get --app=$app --key=days_in_month)
	months_in_year=$(ynh_app_setting_get --app=$app --key=months_in_year)
	months_in_tick=$(ynh_app_setting_get --app=$app --key=months_in_tick)
	years_in_history=$(ynh_app_setting_get --app=$app --key=years_in_history)
	generate_economy_csv=$(ynh_app_setting_get --app=$app --key=generate_economy_csv)
	allow_inter_site_trade=$(ynh_app_setting_get --app=$app --key=allow_inter_site_trade)
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
