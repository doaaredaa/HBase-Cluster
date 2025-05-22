# HBase Cluster Implementation and WebTable Use Case Project

## Overview
This project involves setting up a Highly Available (HA) HBase cluster integrated with an existing Hadoop HA cluster. The implementation includes cluster infrastructure setup, failover testing, Docker containerization, and a WebTable use case to demonstrate HBase functionality.

---

## Technical Requirements

### 1. HBase Cluster Architecture and Integration
- **Cluster Configuration:**
  - 2 Master Nodes (Active/Standby)
  - 2-3 RegionServers
  - 3 ZooKeeper Quorum servers
  - Integration with existing Hadoop HA cluster.

- **Key Tasks:**
  - Configure networking and security.
  - Ensure HBase can access HDFS storage.
  - Set up authentication mechanisms.

### 2. High Availability and Failover
- **Master Node Failover:** Automatic failover using ZooKeeper.
- **RegionServer Failover:** Automatic recovery of regions.
- **Testing:** Simulate failures and document recovery times.

### 3. Containerization and Deployment
- **Docker:** Custom Docker files for all HBase components.
- **Deployment Scripts:** Automated provisioning and validation.

### 4. WebTable Use Case
- **Schema Design:** Implement WebTable schema.
- **Data Ingestion:** Develop data loading processes.
- **Performance Tuning:** Optimize queries and operations.

---

## Deliverables
1. **Infrastructure Code:**
   - Docker files, deployment scripts, configuration files.
2. **WebTable Use Case:**
   - Schema scripts, design docs, query examples.
3. **Testing Documentation:**
   - HA test plans, failure recovery docs.
4. **Technical Documentation:**
   - Architecture overview, setup guide, operational procedures.

---

## Evaluation Criteria
### HBase Cluster Setup:
- **Functionality (50%):** HA, Hadoop integration, WebTable.
- **Code Quality (30%):** Clean Docker files, structured scripts.
- **Documentation (20%):** Completeness, clarity, diagrams.

### WebTable Use Case:
- **Functionality (50%):** Schema design, access patterns.
- **Code Quality (30%):** Organized scripts, optimizations.
- **Documentation (20%):** Clear instructions, explanations.

---

## Bonus Tasks
- **WebTable:** Backup/recovery mechanisms, additional APIs.
- **HBase HA:** Add more nodes, log analysis, monitoring tools.

---

## Milestones
1. **Environment Setup (Days 1-3):** Docker files, networking.
2. **Cluster Deployment (Days 4-6):** ZooKeeper, HBase, Hadoop.
3. **HA Configuration (Days 7-9):** Failover testing.
4. **WebTable Implementation (Days 10-15):** Schema, queries.
5. **Final Testing & Docs (Days 13-15):** Comprehensive review.

---

## References
- [HBase in Docker Guide](https://blog.newnius.com/setup-apache-hbase-in-docker.html)
- [GitHub: HBase Docker](https://github.com/khalidmammadov/hbase_docker)
- [Apache HBase Book](https://hbase.apache.org/book.html)
