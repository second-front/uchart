## Example cronjob and job under microservices:
```
microservices:
  example-cronjob:
    cronjob:
      enabled: true
      schedule: "*/5 * * * *"  # Runs every 5 minutes
      concurrencyPolicy: "Forbid"
      successfulJobsHistoryLimit: 3
      failedJobsHistoryLimit: 1
      suspended: false  # CronJob is not suspended; set to true to disable it
    image:
      repository: "example-repo"
      tag: "1.0.0"
    command:
      - "/bin/sh"
      - "-c"
    args:
      - "/scripts/example-command.sh"  # Command script to run
    envs:
      ENV_VAR_1: "value1"
      ENV_VAR_2: "value2"
  example-job:
    job:
      enabled: true
      backoffLimit: 3
      completions: 1
      parallelism: 1
      suspended: false  # Job will run if false, set to true to skip it
    image:
      repository: "example-repo"
      tag: "1.0.0"
    command:
      - "/bin/sh"
      - "-c"
    args:
      - "/scripts/example-command.sh"  # Command script to run
    envs:
      ENV_VAR_1: "value1"
      ENV_VAR_2: "value2"
```