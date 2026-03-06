# MLperf_project

Purpose:
1. Structural descriptors explain X% of runtime behavior. We now know when structural performance models are reliable and when dynamic behavior must be considered.
2. Answer whether certain operator classes have higher runtime variability to inform scheduling strategies, operator fusion, batching decisions.
3. Performance debugging can focus on a short range of factors
4. How much of GPU operator runtime behavior can be explained by structural kernel properties versus dynamic execution effects?
5. Can a small set of structural and utilization signals predict or diagnose GPU operator runtime behavior in real inference workloads?


Explanatory models:
regression
decision trees
clustering
feature importance
