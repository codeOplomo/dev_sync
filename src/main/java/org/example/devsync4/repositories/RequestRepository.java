package org.example.devsync4.repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.example.devsync4.entities.Request;
import org.example.devsync4.entities.enumerations.RequestStatus;

import java.util.ArrayList;
import java.util.List;

public class RequestRepository {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("myJPAUnit");



    public void update(Request request) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(request); // Merge the updated request entity
        em.getTransaction().commit();
        em.close();
    }

    public Request findById(Long id) {
        EntityManager em = emf.createEntityManager();
        Request request = em.find(Request.class, id);
        em.close();
        return request;
    }
    public void save(Request request) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(request);
        em.getTransaction().commit();
        em.close();
    }

    public List<Request> getRequestsByManager(Long managerId) {
        EntityManager em = emf.createEntityManager();
        List<Request> pendingRequests = new ArrayList<>();

            String jpql = "SELECT r FROM Request r JOIN r.task t WHERE t.createdBy.id = :managerId AND r.status = :status";
            pendingRequests = em.createQuery(jpql, Request.class)
                    .setParameter("managerId", managerId)
                    .setParameter("status", RequestStatus.PENDING)
                    .getResultList();
            em.close();

        return pendingRequests;
    }

    public List<Request> getRequestsByDeveloper(Long developerId) {
        EntityManager em = emf.createEntityManager();
        List<Request> developerRequests = new ArrayList<>();

            String jpql = "SELECT r FROM Request r WHERE r.requestedBy.id = :developerId";
            developerRequests = em.createQuery(jpql, Request.class)
                    .setParameter("developerId", developerId)
                    .getResultList();
            em.close();

        return developerRequests;
    }

    public boolean existsByTaskIdAndRequestedById(Long taskId, Long requestedById) {
        EntityManager em = emf.createEntityManager();

        // Query to count the number of requests that match the given taskId and requestedById
        String jpql = "SELECT COUNT(r) FROM Request r WHERE r.task.id = :taskId AND r.requestedBy.id = :requestedById";
        Long count = em.createQuery(jpql, Long.class)
                .setParameter("taskId", taskId)
                .setParameter("requestedById", requestedById)
                .getSingleResult();

        em.close();

        // If count > 0, a request exists
        return count > 0;
    }
}
