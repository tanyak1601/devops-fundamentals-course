## IaC Tool Investigation

**Docker Compose:**
| Characteristic | Docker Compose |
|---|---|
| Language & Tools | YAML |
| Easy of Use | Relatively easy |
| Clear to Understand | Easy to read and understand |
| Costs | Free |
| Community & Support | Large and active community |
| Maturity | Mature and stable |
| Issues | Limited to local environment |

**CodeBuild vs. GitLab CI:**
| Characteristic | CodeBuild | GitLab CI |
|---|---|---|
| Language & Tools | YAML | YAML |
| Easy of Use | Easy to configure | Moderately easy to configure |
| Clear to Understand | Easy to read and understand | Requires understanding of YAML and GitLab CI syntax |
| Costs | Pay-per-use | Free with self-hosted runner or paid plans with cloud runners |
| Community & Support | Large community, but less specific to CodeBuild | Large and active community |
| Maturity | Mature and stable | Mature and stable |
| Issues | Limited integration with other AWS services | Can be complex to configure for advanced workflows |

**CloudFormation vs. AWS CDK vs. Terraform:**
| Characteristic | CloudFormation | AWS CDK | Terraform |
|---|---|---|---|
| Language & Tools | JSON or YAML | Python, JavaScript, TypeScript, Java, C# | HashiCorp Configuration Language (HCL) |
| Easy of Use | Easy for basic deployments | Requires programming knowledge | Requires understanding of HCL |
| Clear to Understand | Templates can be easy to read | Code can be difficult to understand for non-programmers | Configuration files can be complex |
| Costs | Free | Free | Free |
| Community & Support | Large community | Large and growing community | Large and active community |
| Maturity | Mature and stable | Relatively new | Mature and stable |
| Issues | Limited flexibility and modularity | Requires understanding of programming concepts | Can be verbose and difficult to maintain |

**Proposed Tools:**
* Docker Compose (easy to learn and simplest)
* GitLab CI (provides continuous integration and delivery features)
* Terraform (good for complex project, support, community)
