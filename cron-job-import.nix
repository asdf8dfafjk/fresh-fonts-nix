	services.cron = {
		enable = true;
		systemCronJobs = [
			''*/5 * * * *      root    switch_to_random_nixos_specialisation || echo "$? $(date)" >> /tmp/sp_switched''
		];
	};
