import jenkins.model.Jenkins
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
import hudson.plugins.git.GitSCM
import hudson.plugins.git.UserRemoteConfig
import hudson.plugins.git.BranchSpec

// Get Jenkins instance
def jenkins = Jenkins.getInstance()

// Define job name
def jobName = "tailmate-pipeline"

// Check if job already exists
def job = jenkins.getItem(jobName)

if (job == null) {
  // Create new Pipeline job
  job = jenkins.createProject(WorkflowJob.class, jobName)
  job.setDescription("TailMate Deployment Pipeline")
  
  // Configure SCM
  def userRemoteConfig = new UserRemoteConfig(".", null, null, null)
  def scm = new GitSCM([userRemoteConfig])
  scm.setBranches([new BranchSpec("*/master")])
  
  // Configure Pipeline
  def flowDefinition = new CpsScmFlowDefinition(scm, "Jenkinsfile")
  flowDefinition.setLightweight(true)
  job.setDefinition(flowDefinition)
  
  // Save job
  job.save()
  println("Pipeline job '${jobName}' created successfully")
} else {
  println("Pipeline job '${jobName}' already exists")
}

jenkins.save()
