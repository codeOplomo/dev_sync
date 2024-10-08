package org.example.devsync4.services;

import org.example.devsync4.entities.Tag;
import org.example.devsync4.repositories.TagRepository;
import org.example.devsync4.repositories.UserRepository;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class TagService {

    private final TagRepository tagRepository = new TagRepository();

    public void save(Tag tag) {
        tagRepository.save(tag);
    }

    public void update(Tag tag) {
        tagRepository.update(tag);
    }

    public void delete(Long id) {
        tagRepository.delete(id);
    }

    public List<Tag> findAll() {
        return tagRepository.findAll();
    }

    public List<Tag> findByIds(String[] ids) {
        List<Long> tagIds = Arrays.stream(ids)
                .map(Long::parseLong)
                .collect(Collectors.toList());

        return tagRepository.findByIds(tagIds);
    }
}
