# db-backup

Docker image with all the necessary utilities to backup a Postgres or MariaDB/MySQL database to S3, with optional GPG encryption. The image is based on alpine. It contains:

- pg_dump / pg_dumpall
- mysqldump
- various compressors (gzip, bzip2, xz, lzip, zstd) along with their parallel versions, if available
- gpg
- mcli (minio client) for S3 uploads

See [Dockerfile](Dockerfile) for a full list of installed packages.

## Example Usage in K8S CronJob

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-daily
spec:
  schedule: "@daily"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: backup
              image: ghcr.io/sehrgutesoftware/db-backup:latest
              imagePullPolicy: IfNotPresent
              env:
                - name: S3_ACCESS_KEY
                  valueFrom:
                    secretKeyRef:
                      name: backup-env
                      key: S3_ACCESS_KEY
                - name: S3_SECRET_KEY
                  valueFrom:
                    secretKeyRef:
                      name: backup-env
                      key: S3_SECRET_KEY
                - name: PGPASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: backup-env
                      key: PGPASSWORD
              command:
                - /bin/sh
                - -c
                - |
                  pg_dumpall -h db.postgres.svc.cluster.local -U postgres |\
                  lzip |\
                  MC_HOST_s3="https://$S3_ACCESS_KEY:$S3_SECRET_KEY@s3-endpoint.example.com" \
                  FILENAME=`date "+%Y%m%d-%H%M%S"-all-databases.sql.lz` \
                  mcli pipe s3/bucket/$FILENAME
```
