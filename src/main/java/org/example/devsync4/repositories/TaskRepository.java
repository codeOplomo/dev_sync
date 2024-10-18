package org.example.devsync4.repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import org.example.devsync4.entities.Task;
import org.example.devsync4.entities.enumerations.TaskStatus;

import java.util.List;

public class TaskRepository {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("myJPAUnit");
    //private final EntityManagerFactory emf = jakarta.persistence.Persistence.createEntityManagerFactory("myJPAUnit");

    public List<Task> getTasksAssignedToUser(Long userId) {
        try (EntityManager em = emf.createEntityManager()) {
            String jpql = "SELECT t FROM Task t LEFT JOIN FETCH t.tags WHERE t.assignedTo.id = :userId";
            TypedQuery<Task> query = em.createQuery(jpql, Task.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        }
    }


    public List<Task> findByStatus(TaskStatus status) {
        EntityManager em = emf.createEntityManager();
        List<Task> tasks;
        TypedQuery<Task> query = em.createQuery("SELECT t FROM Task t WHERE t.status = :status", Task.class);
        query.setParameter("status", status);
        tasks = query.getResultList();
        em.close();

        return tasks; // Return the list of tasks found
    }

    public List<Task> findAll() {
        EntityManager em = emf.createEntityManager();
        return em.createQuery("SELECT t FROM Task t", Task.class).getResultList();
    }

    public Task findById(Long id) {
        EntityManager em = emf.createEntityManager();
        return em.find(Task.class, id);
    }

    public Task save(Task task) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(task);
        em.getTransaction().commit();
        em.close();
        return task; // Return the saved entity
    }


    public void update(Task task) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(task);
        em.getTransaction().commit();
        em.close();
    }

    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Task task = em.find(Task.class, id);
        if (task != null) {
            em.remove(task);
        }
        em.getTransaction().commit();
        em.close();
    }

}
