all:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs log *.pod_dir;
	rm -rf deployments *_info_specs;
	rm -rf _build test_ebin ebin;
	rm -rf *.application *.cluster *.deployment *.host;
	mkdir ebin;		
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build test_ebin logs log;
	git add -f *;
	git commit -m $(m);
	git push;
	echo Ok there you go!
build:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs log *.pod_dir;
	rm -rf deployments *_info_specs;
	rm -rf _build test_ebin ebin;
	mkdir ebin;		
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build test_ebin logs log;


clean:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf *.application *.cluster *.deployment *.host;
	rm -rf _build logs log *.pod_dir;
	rm -rf _build test_ebin ebin

eunit:
	rm -rf  *~ */*~ src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs log *.pod_dir;
	rm -rf deployments *_info_specs;
	rm -rf config sd;
	rm -rf rebar.lock;
	rm -rf Mnesia.*;
	rm -rf ebin;
	rm -rf *.application *.cluster *.deployment *.host;
	mkdir test_ebin;
	mkdir ebin;
	rebar3 compile;
	cp _build/default/lib/*/ebin/* ebin;
	cp ../common/ebin/* test_ebin;
	cp ../config_node/ebin/* test_ebin;
	erlc -I include -o test_ebin test/*.erl;
	erl -pa * -pa ebin -pa test_ebin -sname cluster_node_test -run $(m) start -setcookie cluster_node 
