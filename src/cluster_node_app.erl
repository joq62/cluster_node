%%%-------------------------------------------------------------------
%% @doc cluster_node public API
%% @end
%%%-------------------------------------------------------------------

-module(cluster_node_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->

    AllSpec=application:get_all_env(cluster_node),
    io:format("AllSpec ~p~n",[{AllSpec,?MODULE,?LINE}]),
    {application_spec,ApplicationSpec}=lists:keyfind(application_spec,1,AllSpec),
    {cluster_spec,ClusterSpec}=lists:keyfind(cluster_spec,1,AllSpec),
    {deployment_spec,DeploymentSpec}=lists:keyfind(deployment_spec,1,AllSpec),
    {host_spec,HostSpec}=lists:keyfind(host_spec,1,AllSpec),
    {spec_dir,SpecDir}=lists:keyfind(spec_dir,1,AllSpec),
    {log_dir,LogDir}=lists:keyfind(log_dir,1,AllSpec),
    
    
    ConfigNodeEnv=[{config_node,[{deployment_spec,DeploymentSpec},
				 {cluster_spec,ClusterSpec},
				 {host_spec,HostSpec},
				 {application_spec,ApplicationSpec},
				 {spec_dir,SpecDir}]}],

    NodelogEnv=[{nodelog,[{log_dir,LogDir}]}],
    AllEnv=lists:append(ConfigNodeEnv,NodelogEnv),
    ok=application:set_env(AllEnv),

    application:stop(common),
    application:stop(sd),
    application:stop(config_node),
    application:stop(nodelog),

    ok=application:start(common),
    ok=application:start(sd),
    ok=application:start(config_node),
    ok=application:start(nodelog),
 


    cluster_node_sup:start_link([{deployment_spec,DeploymentSpec},
				 {cluster_spec,ClusterSpec},
				 {host_spec,HostSpec},
				 {application_spec,ApplicationSpec},
				 {spec_dir,SpecDir},
				 {log_dir,LogDir}
				]).

stop(_State) ->
    ok.

%% internal functions
