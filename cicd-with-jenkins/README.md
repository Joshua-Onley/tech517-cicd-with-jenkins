# Intro to Jenkins & CICD

- [Intro to Jenkins \& CICD](#intro-to-jenkins--cicd)
  - [CICD Overview](#cicd-overview)
    - [What is CI? Benefits?](#what-is-ci-benefits)
    - [What is CD? Benefits?](#what-is-cd-benefits)
    - [What is Jenkins?](#what-is-jenkins)
    - [Why use Jenkins? Benefits of using Jenkins? Disadvantages?](#why-use-jenkins-benefits-of-using-jenkins-disadvantages)
    - [Stages of Jenkins](#stages-of-jenkins)
    - [What alternatives are there for Jenkins](#what-alternatives-are-there-for-jenkins)
    - [Why build a pipeline? Business value?](#why-build-a-pipeline-business-value)
    - [What is a web hook, why is it needed in the context of a Jenkins pipeline?](#what-is-a-web-hook-why-is-it-needed-in-the-context-of-a-jenkins-pipeline)
  - [Creating and Running Jobs in Jenkins](#creating-and-running-jobs-in-jenkins)
    - [How to Create and Run a Job in Jenkins](#how-to-create-and-run-a-job-in-jenkins)
    - [How to View Console Output From a Job](#how-to-view-console-output-from-a-job)
    - [Triggering the Execution of Jobs](#triggering-the-execution-of-jobs)
  - [Building the CICD Pipeline](#building-the-cicd-pipeline)
    - [Pipeline Architecture](#pipeline-architecture)
    - [Job 1 - Running Tests](#job-1---running-tests)
      - [Pre-requisites](#pre-requisites)
        - [Setting up the GitHub Key Pair](#setting-up-the-github-key-pair)
      - [How to Create Job 1](#how-to-create-job-1)
  - [Setting up the Webhook to Trigger Job 1](#setting-up-the-webhook-to-trigger-job-1)
  - [Job 2 - Merging Dev into Main](#job-2---merging-dev-into-main)
  - [Job 3 - Deploying the Code to an EC2 instance](#job-3---deploying-the-code-to-an-ec2-instance)
  - [Working CI/CD pipeline](#working-cicd-pipeline)

## CICD Overview

### What is CI? Benefits?
* Continuous Integration
* Merging code
* Triggered by: Developers frequently pushing the code changes to shared repo
* Tests are run automatically on the code before it is integrated into the main code

Benefits:
* Help you to identify and resolve bugs early
  * Reduces costs
* Helps to maintain a stable and functional software build

### What is CD? Benefits?
* can mean:
  * Continuous Delivery (manual sign off/approval)
  * Or Continuous Deployment (automatically deploys code to production)
  
Continuous Delivery (manual sign off/approval)
* Ensure software is always in a deployable state, ready/can be pushed to production at any time
* often involves producing deployable artifact
* requires a manual release decision
* benefit
  * always have a deployable artifact ready to deploy to end users 

Continuous Deployment (automatically deploys code to production)
* extends Continuous Delivery by automating the final step of deploying to produciton 
* no manual intervention required
* benefit which is also a disadvantage:
  * removes the need for human approval, relies entirely on automated processes

### What is Jenkins?

* Automation server
* open-source
* primarily used for CICD, but can automate much more

### Why use Jenkins? Benefits of using Jenkins? Disadvantages?

* Benefits:
  * automation
  * extensibility: Jenkins has over 1800 plugins
  * Scalability: Jenkins server can scale easily by adding/using worker nodes/agents to run jobs
  * Community support
  * Cross-platform: Works across windows, linux, MacOS

* Disadvantages:
 * can be complex for beginners
 * Maintenance overhead
 * resource-intensive when running multiple jobs
 * User interface: outdated

### Stages of Jenkins

A typical Jenkins CICD pipeline involves the following stages: 
1. Source Code management (SCM)
2. Build: Compile the code, buidl into executable artifact
3. Test: Automated tests (unit, integration, etc)
4. Package: Package into deployable artifact
5. If using Cont. Deployment, the package is deployed into the target environment e.g. test, production
6. Monitor: Monitoring tools may be deployed/configured to observe performance, log issues, etc after deployment 

### What alternatives are there for Jenkins

* GitLab CI
* GitHub Actions
* CircleCI
* Travis CI
* Bamboo
* TeamCity
* GoCD
* Azure DevOps (Azure Pipelines to run the CICD pipelines)

### Why build a pipeline? Business value?

* Cost savings - automating repetitive processes
* Faster time to market
* reduced risk
* improved quality through continuous feedback and improvement

### What is a web hook, why is it needed in the context of a Jenkins pipeline? 

* A webhook is an HTTP callback: A way for one system to automatically notify another system when a specific even happens. Instead of repeatedly polling for changes, the source system pushes a message to a specific URL when something occurs e.g code is pushed
* The receiving system processes the event and triggers an action

## Creating and Running Jobs in Jenkins


### How to Create and Run a Job in Jenkins

Instructions to create a job:

1. Log into the Jenkins server
2. Click **New item**
* Give the project a name
* Select **freestyle** project
* Click **Ok**
* In the **General** section:
  * Give the project a description e.g. `testing jenkins`
  * Tick the box to discard old builds and set **Max # of builds to keep** to 5
* In the **Build Steps** section:
  1. click add build step
  2. choose execute shell
  3. paste `uname -a` into the text box
  4. click save

* When ready to run the job, click build now 

### How to View Console Output From a Job

* How to find out what happened during a job:
  1. Click on the project link from the dashboard
  2. In the bottom left of the screen, click the link of the job execution
  3. Click **console output**

### Triggering the Execution of Jobs

Jobs can be set to execute on the successful completion of another job:

1. Click on a job
2. Go to the **configure** section
3. Scroll down to **Post-build Actions**
4. Click **Add post-build action** then select **Build other projects**
5. Type in the name of the project you want to run after
6. Leave the **trigger only if build is stable** option selected

## Building the CICD Pipeline

### Pipeline Architecture

The image below shows the pipeline to be built

![jenkins-pipeline](../images/jenkins-pipeline.png)

* The webhook is used to notify Jenkins each time the code in the GitHub repository (dev branch) changes
* The different parts of the architecture connect securely using key pairs
* If the application code is changed e.g. in `app/views/index.js` then pushed to the dev branch, the pipeline executes
* If a job fails, the pipeline stops

### Job 1 - Running Tests
#### Pre-requisites

##### Setting up the GitHub Key Pair

* The Jenkins worker node requies the private key of the GitHub repo key pair to clone the GitHub repository. 

How to setup the repository key pair:

1. Open a terminal window on local machine
2. `cd` into the .ssh folder
3. Run: `ssh-keygen -t rsa -b 4096 -C "<email address>"`
4. Name the key pair: `joshua-jenkins-github-key`
5. Log into GitHub
6. Navigate to the CICD repo
7. Go into the settings for the individual repo
8. Click deploy keys on the left menu
9. Click add deploy key
10. Set the key pair title: `joshua-jenkins-github-key`
11. Copy the public key into the text area:
    1.  Find the `.pub` file created by the `ssh-keygen` command
    2.  Use `cat` to print the key to the terminal
    3.  Copy the entire output to the text area on GitHub for the public key
12. Tick **Allow write access** option - needed for Jenkins to perform `git push` in Job 3.
13. Click **Add key**

#### How to Create Job 1

1. Click **New item** from the Jenkins dashboard
   * Enter item name: `joshua-sparta-app-job1-ci-test`
   * Select Freestyle
2. Click **Ok**
* In the **General** section:
   * Add description: `do testing part of CI with webhook to trigger`
   * Tick **Discard old builds**
     * Strategy: Log rotation
     * Max # of builds to keep: 5
   * Tick **GitHub project** box
      * Project url: `https://github.com/Joshua-Onley/tech517-sparta-test-app-cicd/`
      * ❗Must remove `.git` from URL and replace with `/` if copying URL from GitHub
* In the **Source Code Management** section:
  * Select **Git**
    * Repository URL: `git@github.com:Joshua-Onley/tech517-sparta-test-app-cicd.git`
    * Click **Add** under **credentials**
    * Click **Jenkins**:
      * kind: SSH Username with private key
      * ID: name of key pair = `joshua-jenkins-github-key`
      * Username: `joshua-jenkins-github-key`
      * Description: `read/write to repo`
      * Private key
      * Click **Enter directly**
      * Click **Add**
      * Paste the GitHub repository private key in the text box
    * Branch specifier : */dev
* In the **Build Environment** section:
  * Tick the **provide node and npm bin/ folder to PATH** option

## Setting up the Webhook to Trigger Job 1

1. Select job 1 from dashboard
2. Click configure
3. Scroll down to the **Build triggers** section:
     * Choose GitHub Hook trigger for GITScm polling
4. Click save
5. Go to GitHub repo settings
6. Go to webhooks section
7. Click add webhook
     * Payload URL: `http://34.254.6.118:8080/github-webhook/` (jenkins server)
8. click add webhook


## Job 2 - Merging Dev into Main

1. Click **New item** from the Jenkins dashboard
2. Select option to copy another Job
   * Copy from job 1

* Remove the Webhook
* Navigate to the **Source Code Management** section:
   * ❗Must add SSH agent in the SCM section otherwise git push command will fail

* In the **Execute shell** section paste the following:

  ```bash
  git checkout main
  git merge origin/dev
  git push origin main
  ```
  * `git checkout main` - Switches to the main branch
  * `git merge origin/dev` - Merges the dev branch to the main branch
  * `git push origin main` - Pushes the code to GitHub


## Job 3 - Deploying the Code to an EC2 instance

1. Click **New item** from the Jenkins dashboard
2. Select the option to copy another job
3. 

scp command not working 

```
+ scp -r ./README.md ./app ubuntu@54.195.43.141:~
Host key verification failed.
```
SSH known hosts error

fix: add `-o StrictHostKeyChecking=no` into the scp command


## Working CI/CD pipeline

* Can make a change to the source code on my local machine and push to GitHub (Dev branch)
* The changes are automatically tested, merged with main (only if tests pass), and deployed to EC2 instance

1st change to frontpage: 

![first-change-to-frontpage](../images/first-change-frontpage.png)

Second change to frontpage:

![second-change-to-frontpage](../images/second-change-frontpage.png)


