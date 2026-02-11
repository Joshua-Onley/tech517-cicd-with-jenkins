# Intro to Jenkins & CICD

## What is CI? Benefits?
* Continuous Integration
* Merging code
* Triggered by: Developers frequently pushing the code changes to shared repo
* Tests are run automatically on the code before it is integrated into the main code

Benefits:
* Help you to identify and resolve bugs early
  * Reduces costs
* Helps to maintain a stable and functional software build

## What is CD? Benefits?
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

## What is Jenkins?

* Automation server
* open-source
* primarily used for CICD, but can automate much more

## Why use Jenkins? Benefits of using Jenkins? Disadvantages?

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

## Stages of Jenkins

A typical Jenkins CICD pipeline involves the following stages: 
1. Source Code management (SCM)
2. Build: Compile the code, buidl into executable artifact
3. Test: Automated tests (unit, integration, etc)
4. Package: Package into deployable artifact
5. If using Cont. Deployment, the package is deployed into the target environment e.g. test, production
6. Monitor: Monitoring tools may be deployed/configured to observe performance, log issues, etc after deployment 

## What alternatives are there for Jenkins

* GitLab CI
* GitHub Actions
* CircleCI
* Travis CI
* Bamboo
* TeamCity
* GoCD
* Azure DevOps (Azure Pipelines to run the CICD pipelines)

## Why build a pipeline? Business value?

* Cost savings - automating repetitive processes
* Faster time to market
* reduced risk
* improved quality through continuous feedback and improvement

## What is a web hook, why is it needed in the context of a Jenkins pipeline? 

* A webhook is an HTTP callback: A way for one system to automatically notify another system when a specific even happens. Instead of repeatedly polling for changes, the source system pushes a message to a specific URL when something occurs e.g code is pushed
* The receiving system processes the event and triggers an action

## Our Pipeline

![jenkins-pipeline](../images/jenkins-pipeline.png)

* The webhook is used to notify Jenkins, each time the code in the GitHub repository (dev branch) changes
* The different parts of the architecture connect securely using key pairs
* If the application code is changed e.g. in `app/views/index.js` then pushed to the dev branch, the pipeline executes
* If a job fails, the pipeline stops


## Jenkins codealong (first job)

* Click new item
* Give the item a name
* Click freestyle project
* Click ok
* Each job in diagram is a Jenkins project
* Give description e.g. `testing jenkins`
* Tick box to discard old builds - Each time project runs, there is a new build that is created.
* Set the max number of builds to keep as 5
* Scroll down to build steps
  * click add build step
  * choose execute shell
  * insert uname -a
  * click save
* To change details, click configure
* When ready to run the job,click build now (manual)
* How to find out what happened:
  * click on the project link from dashboard
  * In the bottom left, click on the link
  * Click on console output

## Jenkins codealong (making one job run after another)
* click on the first job `joshua-first-job` from the dashboard
* go to configure
* go to post build actions
* select build other projects
* type in the name of the project you want to run after
* leave trigger only if build is stable option


## Jenkins codealong (setting up repository key pair)
* key pair name: `joshua-jenkins-github-key`
* Open terminal window
* cd .ssh folder
* `ssh-keygen -t rsa -b 4096 -C "<email address>"`
* name it: `joshua-jenkins-github-key`
* log into GitHub
* navigate to repo made for cicd
* go into the settings for the individual repo
* click deploy keys on the left menu
* click add deploy key
* make the title the same as the local keypair name
* copy the public key into the key box
* Tick **Allow write access** option
* Click **Add key**

## Jenkins codealong (setting up job 1)

* Enter item name: `joshua-sparta-app-job1-ci-test`
* Select Freestyle
* Click ok
* Add description: `do testing part of CI with webhook to trigger`
* Tick **Discard old builds**
  * Strategy: Log rotation
  * Max # of builds to keep: 5
* Tick GitHub project
  * Project url: `https://github.com/Joshua-Onley/tech517-sparta-test-app-cicd/`
  * ❗remove `.git` from URL and replace with `/`
* Scroll down to Source Code Management
  * Select Git
    * Repository URL: `git@github.com:Joshua-Onley/tech517-sparta-test-app-cicd.git`
    * Credentials: Add -> Jenkins
      * kind: SSH Username with private key
      * ID: name of key pair = `joshua-jenkins-github-key`
      * Username: `joshua-jenkins-github-key`
      * Description: read/write to repo
      * private key
      * click enter directly
      * click add
      * paste private key
* Branch specifier : */main
* scroll down to build environment 
  * select provide node and npm bin/ folder to PATH