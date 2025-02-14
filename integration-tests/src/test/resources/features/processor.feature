Feature: Processor tests

  Scenario: Processor is created, deployed and correctly deleted
    Given authenticate against Manager
    And create a new Bridge "mybridge" in cloud provider "aws" and region "us-east-1"
    And the Bridge "mybridge" is existing with status "ready" within 4 minutes
    And the Ingress of Bridge "mybridge" is available within 2 minutes

    And add a Processor to the Bridge "mybridge" with body:
    """
    {
      "name": "myProcessor",
      "action": {
        "type": "webhook_sink_0.1",
        "parameters": {
            "endpoint": "https://webhook.site/${env.webhook.site.uuid}"
        }
      }
    }
    """
    And the list of Processor instances of the Bridge "mybridge" is containing the Processor "myProcessor"
    And the Processor "myProcessor" of the Bridge "mybridge" is existing with status "ready" within 3 minutes
    And the Processor "myProcessor" of the Bridge "mybridge" has action of type "webhook_sink_0.1" and parameters:
      | endpoint | https://webhook.site/${env.webhook.site.uuid} |

    When delete the Processor "myProcessor" of the Bridge "mybridge"

    Then the Processor "myProcessor" of the Bridge "mybridge" is not existing within 2 minutes
