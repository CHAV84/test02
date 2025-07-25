pipeline {
    
    agent any

    environment {
        ORACLE_IMAGE = 'my-custom-oracle-image-04_with_ut_installed:latest'
        ORACLE_CONTAINER = 'oracle-db'
        ORACLE_CONTAINER_TEST = 'test-oracle-db'
        ORACLE_PASSWORD = 'oracle'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }

        stage('Debug Workspace') {
    steps {
        sh 'ls -l $WORKSPACE'
    }
}

stage('TEST - Copy SQL Files to Container') {
    steps {
        sh """
            docker cp ${WORKSPACE}/. $ORACLE_CONTAINER_TEST:/tmp/sqlscripts/
        """
    }
}
     
stage('TEST - Debug Container Mount') {
    steps {
        sh """
            docker exec $ORACLE_CONTAINER_TEST ls -l /tmp/sqlscripts
        """
    }
}

stage(' TEST - Run Setup SQL') {
    steps {
        sh '''
            echo "Running setup.sql script..."

            echo "Executing SQL script in container..."
            docker exec $TEST_ORACLE_CONTAINER bash -c '
                sqlplus -s sys/oracle@localhost:1521/orclpdb1 as sysdba <<EOF
                @/tmp/sqlscripts/setup.sql
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
        
stage('Check Oracle Container') {
    steps {
        sh '''
            echo "Checking if test-oracle-db container exists..."
            if [ "$(docker ps -aq -f name=test-oracle-db)" = "" ]; then
                echo "Creating and starting test-oracle-db container..."
                docker run -d --name test-oracle-db -e ORACLE_PASSWORD=$ORACLE_PASSWORD -p 1522:1521 $ORACLE_IMAGE
                if [ $? -ne 0 ]; then
                    echo "Failed to create and start test-oracle-db container."
                    exit 1
                fi
            else
                echo "Container exists. Checking if it is running..."
                if [ "$(docker ps -q -f name=test-oracle-db)" = "" ]; then
                    echo "Starting container..."
                    docker start test-oracle-db
                    if [ $? -ne 0 ]; then
                        echo "Failed to start test-oracle-db container."
                        exit 1
                    fi
                else
                    echo "test-oracle-db is already running."
                fi
            fi
        '''
    }
}

stage('TEST - Connect Container to Jenkins Network') {
    steps {
        sh '''
            echo "Checking if test-oracle-db is connected to 'jenkins' network..."
            if ! docker network inspect jenkins | grep -w '"Name": "test-oracle-db"' > /dev/null; then
                echo "Connecting to jenkins network..."
                docker network connect jenkins test-oracle-db
                if [ $? -ne 0 ]; then
                    echo "Failed to connect to jenkins network."
                    exit 1
                fi
            else
                echo "Already connected to jenkins network."
            fi
        '''
    }
}

stage('TEST - Run utPLSQL Unit Tests') {
    steps {
        sh '''
            echo "Running utPLSQL tests..."
            
            /opt/utPLSQL-cli/bin/utplsql run mikep/mikep@//test-oracle-db:1521/orclpdb1 -p=mikep -f=ut_documentation_reporter -o=run.log -s -f=ut_coverage_html_reporter -o=coverage.html

            EXIT_CODE=$?
            if [ $EXIT_CODE -ne 0 ]; then
                echo "utPLSQL tests failed with exit code $EXIT_CODE"
                exit $EXIT_CODE
            else
                echo "utPLSQL tests passed"
            fi
        '''
    }
}

stage('QS : Clean up old Oracle container') {
            steps {
                sh '''
                    echo "Removing existing Oracle container if it exists..."
                    docker rm -f $ORACLE_CONTAINER || true
                '''
            }
        }
        
stage('QS : Start Oracle DB') {
    steps {
        sh '''
            echo "Starting Oracle container..."
            docker run -d --name $ORACLE_CONTAINER -e ORACLE_PASSWORD=$ORACLE_PASSWORD -p 1521:1521 $ORACLE_IMAGE

            echo "Waiting 90 seconds for Oracle to start..."
            sleep 90
        '''
    }
}
stage('QS - Prepare Network') {
            steps {
                script {
                    // Connect oracle-db container to jenkins network if not already connected
                    sh '''
                    if ! docker network inspect jenkins | grep -qw '"Name": "oracle-db"'; then
                        docker network connect jenkins oracle-db
                        echo "oracle-db connected to jenkins network"
                    else
                        echo "oracle-db already connected to jenkins network"
                    fi
                    '''
                }
            }
        }
        
stage('Copy SQL Files to Container') {
    steps {
        sh """
            docker cp ${WORKSPACE}/. oracle-db:/tmp/sqlscripts/
        """
    }
}
     
stage('Debug Container Mount') {
    steps {
        sh """
            docker exec $ORACLE_CONTAINER ls -l /tmp/sqlscripts
        """
    }
}

stage('Run Setup SQL') {
    steps {
        sh '''
            echo "Running setup.sql script..."

            echo "Executing SQL script in container..."
            docker exec $ORACLE_CONTAINER bash -c '
                sqlplus -s sys/oracle@localhost:1521/orclpdb1 as sysdba <<EOF
                @/tmp/sqlscripts/setup.sql
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

stage('Run utPLSQL Tests') {
      steps {
        // Call the utplsql CLI script with parameters
        sh '/opt/utPLSQL-cli/bin/utplsql run mikep/mikep@//oracle-db:1521/orclpdb1 -p=mikep -f=ut_documentation_reporter -o=run.log -s -f=ut_coverage_html_reporter -o=coverage.html'
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
