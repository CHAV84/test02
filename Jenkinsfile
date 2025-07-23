pipeline {
    agent any

    environment {
        ORACLE_IMAGE = 'my-custom-oracle-image-01:latest'
        ORACLE_CONTAINER = 'oracle-db'
        ORACLE_PASSWORD = 'oracle'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Clean up old Oracle container') {
            steps {
                sh '''
                    echo "Removing existing Oracle container if it exists..."
                    docker rm -f $ORACLE_CONTAINER || true
                '''
            }
        }

stage('Start Oracle DB') {
    steps {
        sh '''
            echo "Starting Oracle container..."
            docker run -d --name oracle-db -e ORACLE_PASSWORD=password -p 1521:1521 my-custom-oracle-image-01:latest

            echo "Waiting 10 seconds for Oracle to start..."
            sleep 90
        '''
    }
}

stage('Run Setup SQL') {
    steps {
        sh '''
            echo "Running setup.sql script..."
            docker cp setup.sql $ORACLE_CONTAINER:/tmp/setup.sql

            echo "Executing SQL script in container..."
            docker exec $ORACLE_CONTAINER bash -c '
                sqlplus -s sys/oracle@localhost:1521/orclpdb1 as sysdba <<EOF
                @/tmp/setup.sql
                EXIT
EOF
            '
            if [ $? -ne 0 ]; then
                echo "SQL*Plus execution failed!"
                exit 1
            fi
        '''
    }
}

        stage('Use Oracle DB') {
            steps {
                echo 'Oracle DB is up and configured.'
                // Add your test, build, or integration steps here
            }
        }
    }
/*
    post {
        always {
            sh '''
                echo "Cleaning up Oracle container..."
                docker rm -f $ORACLE_CONTAINER || true
            '''
        }
    }
    */
}
