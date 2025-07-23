pipeline {
    agent any

    environment {
        ORACLE_IMAGE = 'my-custom-oracle-image:latest'
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
                    docker run -d --name $ORACLE_CONTAINER -e ORACLE_PASSWORD=$ORACLE_PASSWORD -p 1521:1521 $ORACLE_IMAGE

                    echo "Waiting for Oracle to be ready..."
                    for i in {1..30}; do
                        if docker exec $ORACLE_CONTAINER bash -c "echo 'SELECT 1 FROM dual;' | sqlplus -s system/$ORACLE_PASSWORD@localhost/XEPDB1"; then
                            echo "Oracle is ready!"
                            break
                        else
                            echo "Waiting... ($i)"
                            sleep 10
                        fi
                    done
                '''
            }
        }

        stage('Run Setup SQL') {
            steps {
                sh '''
                    echo "Running setup.sql script..."
                    docker cp setup.sql $ORACLE_CONTAINER:/tmp/setup.sql
                    docker exec $ORACLE_CONTAINER bash -c "echo '@/tmp/setup.sql' | sqlplus system/$ORACLE_PASSWORD@localhost/XEPDB1"
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

    post {
        always {
            sh '''
                echo "Cleaning up Oracle container..."
                docker rm -f $ORACLE_CONTAINER || true
            '''
        }
    }
}
