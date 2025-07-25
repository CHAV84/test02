pipeline {
    
    agent any

    environment {
        ORACLE_IMAGE = 'my-custom-oracle-image-04_with_ut_installed:latest'
        ORACLE_CONTAINER = 'oracle-db'
        TEST_ORACLE_CONTAINER = 'test-oracle-db'
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

stage('Run Unit Tests') {
    steps {
        sh '''
            echo "🔍 Checking if test-oracle-db is running..."
            if [ "$(docker ps -q -f name=test-oracle-db)" = "" ]; then
                echo "Starting test-oracle-db container..."
                docker start test-oracle-db || docker run -d --name $TEST_ORACLE_CONTAINER -e ORACLE_PASSWORD=$ORACLE_PASSWORD -p 1522:1521 $ORACLE_IMAGE
            else
                echo "$TEST_ORACLE_CONTAINER already running."
            fi

            echo "Making sure test-oracle-db is connected to 'jenkins' network..."
            docker network inspect jenkins | grep test-oracle-db > /dev/null
            if [ $? -ne 0 ]; then
                echo "Connecting test-oracle-db to jenkins network..."
                docker network connect jenkins test-oracle-db || true
            else
                echo "test-oracle-db already connected to jenkins network."
            fi

            echo "TEST : Running utPLSQL tests..."
            /opt/utPLSQL-cli/bin/utplsql run mikep/mikep@//test-oracle-db:1522/orclpdb1 \
                -p=mikep \
                -f=ut_documentation_reporter -o=run.log \
                -s \
                -f=ut_coverage_html_reporter -o=coverage.html

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
        stage('Prepare Network') {
            steps {
                script {
                    // Connect oracle-db container to jenkins network if not already connected
                    sh '''
                    if ! docker network inspect jenkins | grep -q oracle-db; then
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
